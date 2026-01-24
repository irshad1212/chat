import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chat/src/chat/views/chat_view.dart';
import 'package:chat/src/chat/widgets/chat_app_bar.dart';
import 'package:chat/src/chat/notifiers/chat_notifier.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String userId;
  final String userName;
  final String? profileImage;

  const ChatPage({super.key, required this.userId, required this.userName, this.profileImage});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final String _currentUserId = 'me';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatNotifierProvider.notifier).loadInitialMessages(widget.userId, widget.userName);
    });
  }

  Future<void> _handleMessageSend(String text) async {
    await ref.read(chatNotifierProvider.notifier).sendMessage(text, _currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatNotifierProvider);
    final messages = chatState.messages;

    return Scaffold(
      appBar: ChatAppBar(userId: widget.userId, userName: widget.userName),
      body: ChatView(
        currentUserId: _currentUserId,
        messages: messages,
        onMessageSend: _handleMessageSend,
      ),
    );
  }
}
