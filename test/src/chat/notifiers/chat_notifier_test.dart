import 'package:chat/core/enums/message_status.dart';
import 'package:chat/src/chat/dtos/comment_dto.dart';
import 'package:chat/src/chat/models/chat_message.dart';
import 'package:chat/src/chat/notifiers/chat_notifier.dart';
import 'package:chat/src/chat/repository/chat_repository.dart';
import 'package:chat/src/chat/repository/chat_repository_provider.dart';
import 'package:chat/utils/helpers/loader_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_client/remote_client.dart';

/// Mock repository for testing
class MockChatRepository implements ChatRepository {
  bool shouldFail = false;
  int callCount = 0;
  int? lastRequestedId;

  @override
  Future<Either<Failure, CommentDto>> getRandomMessage(int id) async {
    callCount++;
    lastRequestedId = id;

    await Future.delayed(const Duration(milliseconds: 50));

    if (shouldFail) {
      return const Left(Unexpected(message: 'Network error'));
    }

    return Right(
      CommentDto(
        postId: 1,
        id: id,
        name: 'Mock User',
        email: 'mock@example.com',
        body: 'This is a mock reply message',
      ),
    );
  }
}

/// Test provider function
ChatRepository testChatRepo(Ref ref, MockChatRepository mockRepository) => mockRepository;

void main() {
  late ProviderContainer container;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    container = ProviderContainer(
      overrides: [chatRepositoryProvider.overrideWith((ref) => testChatRepo(ref, mockRepository))],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ChatNotifier', () {
    group('initial state', () {
      test('should have empty messages list', () {
        final state = container.read(chatNotifierProvider);

        expect(state.messages, isEmpty);
        expect(state.sendStatus, isA<Initial>());
        expect(state.isTyping, false);
      });
    });

    group('loadInitialMessages', () {
      test('should add welcome message to empty list', () async {
        final notifier = container.read(chatNotifierProvider.notifier);

        await notifier.loadInitialMessages('user_123', 'John Doe');

        final state = container.read(chatNotifierProvider);
        expect(state.messages.length, 1);

        final message = state.messages.first as TextChatMessage;
        expect(message.authorId, 'user_123');
        expect(message.text, 'Hi! This is John Doe.');
        expect(message.status, MessageStatus.delivered);
      });

      test('should not duplicate welcome message on multiple calls', () async {
        final notifier = container.read(chatNotifierProvider.notifier);

        await notifier.loadInitialMessages('user_123', 'John Doe');
        await notifier.loadInitialMessages('user_123', 'John Doe');

        final state = container.read(chatNotifierProvider);
        expect(state.messages.length, 1);
      });

      test('should set createdAt to past time', () async {
        final notifier = container.read(chatNotifierProvider.notifier);
        final before = DateTime.now().subtract(const Duration(minutes: 2));

        await notifier.loadInitialMessages('user_123', 'Test User');

        final state = container.read(chatNotifierProvider);
        final message = state.messages.first as TextChatMessage;
        final after = DateTime.now();

        expect(message.createdAt, isNotNull);
        expect(message.createdAt!.isAfter(before), true);
        expect(message.createdAt!.isBefore(after), true);
      });
    });

    group('sendMessage', () {
      test('should add message with sending status optimistically', () async {
        final notifier = container.read(chatNotifierProvider.notifier);

        // Start sending (don't await)
        final sendFuture = notifier.sendMessage('Hello!', 'user_123');

        // Check immediate state
        await Future.delayed(const Duration(milliseconds: 10));
        var state = container.read(chatNotifierProvider);

        expect(state.messages.length, 1);
        final message = state.messages.first as TextChatMessage;
        expect(message.text, 'Hello!');
        expect(message.authorId, 'user_123');
        expect(message.status, MessageStatus.sending);

        await sendFuture;

        // After completion, status should be sent
        state = container.read(chatNotifierProvider);
        final updatedMessage = state.messages.first as TextChatMessage;
        expect(updatedMessage.status, MessageStatus.sent);
      });

      test('should update sendStatus to loading during send', () async {
        final notifier = container.read(chatNotifierProvider.notifier);

        final sendFuture = notifier.sendMessage('Test', 'user_123');
        await Future.delayed(const Duration(milliseconds: 10));

        var state = container.read(chatNotifierProvider);
        expect(state.sendStatus, isA<Loading>());

        await sendFuture;
      });

      test('should trigger auto-reply after sending', () async {
        final notifier = container.read(chatNotifierProvider.notifier);

        await notifier.sendMessage('Hello!', 'user_123');

        final state = container.read(chatNotifierProvider);
        // Should have user message + reply
        expect(state.messages.length, 2);

        final userMessage = state.messages[0] as TextChatMessage;
        final replyMessage = state.messages[1] as TextChatMessage;

        expect(userMessage.authorId, 'user_123');
        expect(replyMessage.authorId, startsWith('other_'));
        expect(replyMessage.text, 'This is a mock reply message');
      });

      test('should set sendStatus to success after complete flow', () async {
        final notifier = container.read(chatNotifierProvider.notifier);

        await notifier.sendMessage('Test', 'user_123');

        final state = container.read(chatNotifierProvider);
        expect(state.sendStatus, isA<Success>());
      });

      test('should handle network error during reply fetch', () async {
        mockRepository.shouldFail = true;
        final notifier = container.read(chatNotifierProvider.notifier);

        await notifier.sendMessage('Test', 'user_123');

        final state = container.read(chatNotifierProvider);
        expect(state.sendStatus, isA<LoadError>());

        final error = state.sendStatus as LoadError;
        expect(error.failure.message, 'Network error');
      });

      test('should show typing indicator during reply fetch', () async {
        final notifier = container.read(chatNotifierProvider.notifier);

        final sendFuture = notifier.sendMessage('Test', 'user_123');

        // Wait for user message to be sent and reply to start
        await Future.delayed(const Duration(milliseconds: 350));

        var state = container.read(chatNotifierProvider);
        expect(state.isTyping, true);

        await sendFuture;

        state = container.read(chatNotifierProvider);
        expect(state.isTyping, false);
      });

      test('should hide typing indicator after error', () async {
        mockRepository.shouldFail = true;
        final notifier = container.read(chatNotifierProvider.notifier);

        await notifier.sendMessage('Test', 'user_123');

        final state = container.read(chatNotifierProvider);
        expect(state.isTyping, false);
      });

      test('should handle multiple consecutive messages', () async {
        final notifier = container.read(chatNotifierProvider.notifier);

        await notifier.sendMessage('Message 1', 'user_123');
        await notifier.sendMessage('Message 2', 'user_123');
        await notifier.sendMessage('Message 3', 'user_123');

        final state = container.read(chatNotifierProvider);
        // 3 user messages + 3 replies = 6 total
        expect(state.messages.length, 6);

        var userMessageCount = 0;
        var replyCount = 0;

        for (final msg in state.messages) {
          final textMsg = msg as TextChatMessage;
          if (textMsg.authorId == 'user_123') {
            userMessageCount++;
          } else {
            replyCount++;
          }
        }

        expect(userMessageCount, 3);
        expect(replyCount, 3);
      });

      test('should call repository with random ID', () async {
        final notifier = container.read(chatNotifierProvider.notifier);

        await notifier.sendMessage('Test', 'user_123');

        expect(mockRepository.callCount, 1);
        expect(mockRepository.lastRequestedId, isNotNull);
        expect(mockRepository.lastRequestedId! >= 1, true);
        expect(mockRepository.lastRequestedId! <= 501, true);
      });

      test('should generate unique message IDs', () async {
        final notifier = container.read(chatNotifierProvider.notifier);

        await notifier.sendMessage('Message 1', 'user_123');
        await notifier.sendMessage('Message 2', 'user_123');

        final state = container.read(chatNotifierProvider);
        final ids = state.messages.map((m) => m.id).toSet();

        // All IDs should be unique
        expect(ids.length, state.messages.length);
      });
    });

    group('message status updates', () {
      test('should update message status correctly', () async {
        final notifier = container.read(chatNotifierProvider.notifier);

        await notifier.sendMessage('Test', 'user_123');

        final state = container.read(chatNotifierProvider);
        final userMessage = state.messages.first as TextChatMessage;

        // Should have been updated from sending to sent
        expect(userMessage.status, MessageStatus.sent);
      });

      test('should preserve other message data during status update', () async {
        final notifier = container.read(chatNotifierProvider.notifier);

        await notifier.sendMessage('Test message', 'user_456');

        final state = container.read(chatNotifierProvider);
        final message = state.messages.first as TextChatMessage;

        expect(message.text, 'Test message');
        expect(message.authorId, 'user_456');
        expect(message.createdAt, isNotNull);
      });
    });
  });
}
