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

/// Mock repository implementation for success scenarios
class MockSuccessRepository implements ChatRepository {
  int callCount = 0;

  @override
  Future<Either<Failure, CommentDto>> getRandomMessage(int id) async {
    callCount++;
    await Future.delayed(const Duration(milliseconds: 50));

    return Right(
      CommentDto(
        postId: 1,
        id: id,
        name: 'API User',
        email: 'api@example.com',
        body: 'This is an automated reply from the API',
      ),
    );
  }
}

/// Mock repository implementation for failure scenarios
class MockFailureRepository implements ChatRepository {
  @override
  Future<Either<Failure, CommentDto>> getRandomMessage(int id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return const Left(Unexpected(message: 'Network connection failed'));
  }
}

/// Test provider for success scenarios - returns mock repository instance
ChatRepository testSuccessChatRepo(Ref ref) => MockSuccessRepository();

/// Test provider for failure scenarios - returns mock repository instance
ChatRepository testFailureChatRepo(Ref ref) => MockFailureRepository();

void main() {
  group('Chat Module Integration Tests', () {
    group('Full message flow with success', () {
      late ProviderContainer container;

      setUp(() {
        container = ProviderContainer(
          overrides: [chatRepositoryProvider.overrideWith(testSuccessChatRepo)],
        );
      });

      tearDown(() {
        container.dispose();
      });

      test('should complete full chat initialization and send flow', () async {
        // Initial state
        var state = container.read(chatNotifierProvider);
        expect(state.messages, isEmpty);
        expect(state.sendStatus, isA<Initial>());
        expect(state.isTyping, false);

        // Load initial message
        final notifier = container.read(chatNotifierProvider.notifier);
        await notifier.loadInitialMessages('user_123', 'John Doe');

        state = container.read(chatNotifierProvider);
        expect(state.messages.length, 1);

        final welcomeMsg = state.messages.first as TextChatMessage;
        expect(welcomeMsg.text, 'Hi! This is John Doe.');
        expect(welcomeMsg.authorId, 'user_123');

        // Send a message
        await notifier.sendMessage('Hello there!', 'user_123');

        state = container.read(chatNotifierProvider);
        // Welcome + user message + auto-reply = 3
        expect(state.messages.length, 3);
        expect(state.sendStatus, isA<Success>());
        expect(state.isTyping, false);

        final userMsg = state.messages[1] as TextChatMessage;
        expect(userMsg.text, 'Hello there!');
        expect(userMsg.authorId, 'user_123');
        expect(userMsg.status, MessageStatus.sent);

        final replyMsg = state.messages[2] as TextChatMessage;
        expect(replyMsg.text, 'This is an automated reply from the API');
        expect(replyMsg.authorId, startsWith('other_'));
        expect(replyMsg.status, MessageStatus.delivered);
      });

      test('should handle complete conversation flow', () async {
        final notifier = container.read(chatNotifierProvider.notifier);

        // Initialize
        await notifier.loadInitialMessages('user_456', 'Jane Smith');

        // Send multiple messages
        await notifier.sendMessage('First message', 'user_456');
        await notifier.sendMessage('Second message', 'user_456');
        await notifier.sendMessage('Third message', 'user_456');

        final state = container.read(chatNotifierProvider);

        // Welcome + 3 user messages + 3 replies = 7
        expect(state.messages.length, 7);

        // Verify message order
        final textMessages = state.messages.cast<TextChatMessage>();
        expect(textMessages[0].text, contains('Jane Smith'));
        expect(textMessages[1].text, 'First message');
        expect(textMessages[2].text, 'This is an automated reply from the API');
        expect(textMessages[3].text, 'Second message');
        expect(textMessages[4].text, 'This is an automated reply from the API');
        expect(textMessages[5].text, 'Third message');
        expect(textMessages[6].text, 'This is an automated reply from the API');
      });

      test('should maintain state consistency across operations', () async {
        final notifier = container.read(chatNotifierProvider.notifier);

        await notifier.loadInitialMessages('user_789', 'Test User');
        await notifier.sendMessage('Test', 'user_789');

        // Read state multiple times
        final state1 = container.read(chatNotifierProvider);
        final state2 = container.read(chatNotifierProvider);

        expect(state1.messages.length, state2.messages.length);
        expect(state1.isTyping, state2.isTyping);
        expect(state1.sendStatus.runtimeType, state2.sendStatus.runtimeType);
      });

      test('should handle typing indicator lifecycle', () async {
        final notifier = container.read(chatNotifierProvider.notifier);

        // Start before typing
        var state = container.read(chatNotifierProvider);
        expect(state.isTyping, false);

        // Send message (don't await)
        final sendFuture = notifier.sendMessage('Test', 'user_123');

        // Wait for typing to start
        await Future.delayed(const Duration(milliseconds: 350));
        state = container.read(chatNotifierProvider);
        expect(state.isTyping, true);

        // Complete send
        await sendFuture;
        state = container.read(chatNotifierProvider);
        expect(state.isTyping, false);
      });

      test('should correctly transition message statuses', () async {
        final notifier = container.read(chatNotifierProvider.notifier);

        final sendFuture = notifier.sendMessage('Status test', 'user_123');

        // Check sending status
        await Future.delayed(const Duration(milliseconds: 10));
        var state = container.read(chatNotifierProvider);
        var userMsg = state.messages.first as TextChatMessage;
        expect(userMsg.status, MessageStatus.sending);

        // Wait for completion
        await sendFuture;

        // Check sent status
        state = container.read(chatNotifierProvider);
        userMsg = state.messages.first as TextChatMessage;
        expect(userMsg.status, MessageStatus.sent);
      });
    });

    group('Full message flow with failure', () {
      late ProviderContainer container;

      setUp(() {
        container = ProviderContainer(
          overrides: [chatRepositoryProvider.overrideWith(testFailureChatRepo)],
        );
      });

      tearDown(() {
        container.dispose();
      });

      test('should handle network error gracefully', () async {
        final notifier = container.read(chatNotifierProvider.notifier);

        await notifier.loadInitialMessages('user_123', 'John Doe');
        await notifier.sendMessage('This will fail', 'user_123');

        final state = container.read(chatNotifierProvider);

        // Should have welcome + user message (no reply due to error)
        expect(state.messages.length, 2);
        expect(state.sendStatus, isA<LoadError>());
        expect(state.isTyping, false);

        final error = state.sendStatus as LoadError;
        expect(error.failure.message, 'Network connection failed');
      });

      test('should still add user message when reply fails', () async {
        final notifier = container.read(chatNotifierProvider.notifier);

        await notifier.sendMessage('Test message', 'user_456');

        final state = container.read(chatNotifierProvider);
        expect(state.messages.length, 1);

        final msg = state.messages.first as TextChatMessage;
        expect(msg.text, 'Test message');
        expect(msg.authorId, 'user_456');
        expect(msg.status, MessageStatus.sent);
      });

      test('should clear typing indicator on error', () async {
        final notifier = container.read(chatNotifierProvider.notifier);

        await notifier.sendMessage('Test', 'user_123');

        final state = container.read(chatNotifierProvider);
        expect(state.isTyping, false);
      });
    });

    group('State management integration', () {
      test('should handle rapid state changes', () async {
        final container = ProviderContainer(
          overrides: [chatRepositoryProvider.overrideWith(testSuccessChatRepo)],
        );

        final notifier = container.read(chatNotifierProvider.notifier);

        // Rapid operations
        await notifier.loadInitialMessages('user_123', 'Test');
        await notifier.sendMessage('1', 'user_123');
        await notifier.sendMessage('2', 'user_123');

        final state = container.read(chatNotifierProvider);
        expect(state.messages.length, 5); // welcome + 2 user + 2 replies

        container.dispose();
      });

      test('should preserve message data integrity', () async {
        final container = ProviderContainer(
          overrides: [chatRepositoryProvider.overrideWith(testSuccessChatRepo)],
        );

        final notifier = container.read(chatNotifierProvider.notifier);
        await notifier.sendMessage('Integrity test', 'user_999');

        final state = container.read(chatNotifierProvider);
        final msg = state.messages.first as TextChatMessage;

        // Verify data integrity
        expect(msg.id.isNotEmpty, true);
        expect(msg.authorId, 'user_999');
        expect(msg.text, 'Integrity test');
        expect(msg.createdAt, isNotNull);
        expect(msg.status, MessageStatus.sent);

        container.dispose();
      });

      test('should properly cleanup on dispose', () async {
        final container = ProviderContainer(
          overrides: [chatRepositoryProvider.overrideWith(testSuccessChatRepo)],
        );

        final notifier = container.read(chatNotifierProvider.notifier);
        await notifier.sendMessage('Test', 'user_123');

        expect(container.read(chatNotifierProvider).messages.isNotEmpty, true);

        container.dispose();
        // Container disposed, no further operations should occur
      });
    });
  });
}
