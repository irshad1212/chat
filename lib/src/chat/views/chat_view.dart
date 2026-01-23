import 'package:chat/core/enums/message_group_status.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat/src/chat/models/chat_message.dart';
import 'package:chat/src/chat/widgets/text_composer.dart';
import 'package:chat/src/chat/widgets/text_message.dart';

class ChatView extends ConsumerStatefulWidget {
  final String currentUserId;
  final List<ChatMessage> messages;
  final Function(String) onMessageSend;

  const ChatView({
    super.key,
    required this.currentUserId,
    required this.messages,
    required this.onMessageSend,
  });

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _scrollController = ScrollController();
  int _currentMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _currentMessageCount = widget.messages.length;
  }

  @override
  void didUpdateWidget(ChatView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _onMessagesChanged(widget.messages);
  }

  void _onMessagesChanged(List<ChatMessage> messages) {
    final newLength = messages.length;

    if (newLength > _currentMessageCount) {
      // Messages added
      for (int i = _currentMessageCount; i < newLength; i++) {
        _listKey.currentState?.insertItem(0);
      }
      // Jump to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
      });
    } else if (newLength < _currentMessageCount) {
      // Messages removed
      for (int i = _currentMessageCount - 1; i >= newLength; i--) {
        _listKey.currentState?.removeItem(i, (context, animation) => const SizedBox.shrink());
      }
    }
    _currentMessageCount = newLength;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              key: _listKey,
              initialItemCount: widget.messages.length,
              reverse: true,
              itemBuilder: (context, index, animation) {
                final reversedIndex = widget.messages.length - 1 - index;
                final message = widget.messages[reversedIndex];
                final isSentByMe = message.authorId == widget.currentUserId;

                // Calculate message grouping
                final groupStatus = _calculateGroupStatus(reversedIndex);

                return switch (message) {
                  TextChatMessage() when isSentByMe => TextMessageBubble.self(
                    message: message,
                    index: reversedIndex,
                    animation: animation,
                    groupStatus: groupStatus,
                  ),
                  TextChatMessage() => TextMessageBubble.other(
                    message: message,
                    index: reversedIndex,
                    animation: animation,
                    groupStatus: groupStatus,
                  ),
                  _ => const SizedBox.shrink(),
                };
              },
            ),
          ),
          SimpleTextComposer(onSend: widget.onMessageSend),
        ],
      ),
    );
  }

  MessageGroupStatus? _calculateGroupStatus(int index) {
    final messages = widget.messages;
    if (index < 0 || index >= messages.length) return null;

    final currentMessage = messages[index];
    if (currentMessage is! TextChatMessage) return null;

    final prevMessage = index > 0 ? messages[index - 1] : null;
    final nextMessage = index < messages.length - 1 ? messages[index + 1] : null;

    final isSameAuthorAsPrev =
        prevMessage is TextChatMessage && prevMessage.authorId == currentMessage.authorId;
    final isSameAuthorAsNext =
        nextMessage is TextChatMessage && nextMessage.authorId == currentMessage.authorId;

    if (isSameAuthorAsPrev && isSameAuthorAsNext) {
      return MessageGroupStatus.middle;
    } else if (isSameAuthorAsPrev) {
      return MessageGroupStatus.last;
    } else if (isSameAuthorAsNext) {
      return MessageGroupStatus.first;
    } else {
      return MessageGroupStatus.single;
    }
  }
}
