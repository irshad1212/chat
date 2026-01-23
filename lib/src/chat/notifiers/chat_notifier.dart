import 'dart:math';

import 'package:chat/core/enums/message_status.dart';
import 'package:chat/src/chat/models/chat_message.dart';
import 'package:chat/src/chat/repository/chat_repository.dart';
import 'package:chat/src/chat/repository/chat_repository_provider.dart';
import 'package:chat/src/chat/states/chat_state.dart';
import 'package:chat/utils/helpers/loader_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ulid/ulid.dart';

part 'chat_notifier.g.dart';

@riverpod
class ChatNotifier extends _$ChatNotifier {
  late final ChatRepository _repository;

  @override
  ChatState build() {
    _repository = ref.read(chatRepositoryProvider);
    return ChatState.initial();
  }

  /// Load initial messages
  Future<void> loadInitialMessages(String userId, String userName) async {
    final welcomeMessage = TextChatMessage(
      id: Ulid().toString(),
      authorId: userId,
      text: 'Hi! This is $userName.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
      status: MessageStatus.delivered,
    );

    // Only add if list is empty to prevent duplicates on rebuilds if logical
    if (state.messages.isEmpty) {
      state = state.copyWith(messages: [...state.messages, welcomeMessage]);
    }
  }

  /// Send a message
  Future<void> sendMessage(String text, String authorId) async {
    final userMessage = TextChatMessage(
      id: Ulid().toString(),
      authorId: authorId,
      text: text,
      createdAt: DateTime.now(),
      status: MessageStatus.sending,
    );

    // Optimistic update
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      sendStatus: const LoaderState.loading(),
    );

    // Simulate delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Update status to sent (in a real app, this would be from server)
    _updateMessageStatus(userMessage.id, MessageStatus.sent);

    // Fetch reply
    await _fetchReply(authorId);
  }

  Future<void> _fetchReply(String currentUserId) async {
    // Set typing indicator
    state = state.copyWith(isTyping: true);

    // Random ID between 1 and 500
    final randomId = Random().nextInt(500) + 1;

    final result = await _repository.getRandomMessage(randomId);

    result.fold(
      (failure) {
        state = state.copyWith(sendStatus: LoaderState.loadError(failure), isTyping: false);
      },
      (commentDto) {
        final replyMessage = commentDto.toDomain(currentUserId: currentUserId, isOther: true);
        state = state.copyWith(
          messages: [...state.messages, replyMessage],
          sendStatus: const LoaderState.success(data: null),
          isTyping: false,
        );
      },
    );
  }

  void _updateMessageStatus(String id, MessageStatus status) {
    state = state.copyWith(
      messages: state.messages.map((msg) {
        if (msg.id == id && msg is TextChatMessage) {
          return msg.copyWith(status: status);
        }
        return msg;
      }).toList(),
    );
  }
}
