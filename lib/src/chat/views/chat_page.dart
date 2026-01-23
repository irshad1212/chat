import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulid/ulid.dart';

import 'package:chat/src/chat/views/chat_view.dart';
import 'package:chat/src/chat/widgets/chat_app_bar.dart';
import 'package:chat/src/shared/controllers/chat_controller.dart';
import 'package:chat/src/chat/models/chat_message.dart';
import 'package:chat/core/enums/message_status.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String userId;
  final String userName;
  final String? profileImage;

  const ChatPage({super.key, required this.userId, required this.userName, this.profileImage});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  late final ChatController _chatController;
  final String _currentUserId = 'me';

  @override
  void initState() {
    super.initState();
    _chatController = ChatController();
    _loadInitialMessages();
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialMessages() async {
    // Initial welcome message
    await _chatController.insertMessage(
      TextChatMessage(
        id: Ulid().toString(),
        authorId: widget.userId,
        text: 'Hi! This is ${widget.userName}.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
        status: MessageStatus.delivered,
      ),
    );
  }

  Future<void> _handleMessageSend(String text) async {
    final message = TextChatMessage(
      id: Ulid().toString(),
      authorId: _currentUserId,
      text: text,
      createdAt: DateTime.now(),
      status: MessageStatus.sending,
    );

    await _chatController.insertMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(userId: widget.userId, userName: widget.userName),
      body: ChatView(
        currentUserId: _currentUserId,
        controller: _chatController,
        onMessageSend: _handleMessageSend,
      ),
    );
  }
}
