import 'package:chat/core/enums/message_group_status.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat/src/chat/models/chat_message.dart';
import 'package:chat/src/chat/widgets/text_composer.dart';
import 'package:chat/src/chat/widgets/text_message.dart';
import 'package:chat/src/shared/controllers/chat_controller.dart';

class ChatView extends ConsumerStatefulWidget {
  final String currentUserId;
  final ChatController controller;
  final Function(String) onMessageSend;

  const ChatView({
    super.key,
    required this.currentUserId,
    required this.controller,
    required this.onMessageSend,
  });

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _scrollController = ScrollController();
  final List<AnimationController> _animationControllers = [];

  @override
  void initState() {
    super.initState();
    widget.controller.messagesStream.listen(_onMessagesChanged);

    for (int i = 0; i < widget.controller.messages.length; i++) {
      _animationControllers.add(_createAnimationController());
    }
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  AnimationController _createAnimationController() {
    final controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    controller.forward();
    return controller;
  }

  void _onMessagesChanged(List<ChatMessage> messages) {
    final oldLength = _animationControllers.length;
    final newLength = messages.length;

    if (newLength > oldLength) {
      // Messages added
      for (int i = oldLength; i < newLength; i++) {
        _animationControllers.add(_createAnimationController());
        _listKey.currentState?.insertItem(0);
      }
      // Jump to bottom without animation
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
      });
    } else if (newLength < oldLength) {
      // Messages removed
      for (int i = oldLength - 1; i >= newLength; i--) {
        final controller = _animationControllers.removeAt(i);
        _listKey.currentState?.removeItem(i, (context, animation) => const SizedBox.shrink());
        controller.dispose();
      }
    }
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
              padding: EdgeInsets.only(bottom: 12.h),
              key: _listKey,
              initialItemCount: widget.controller.messages.length,
              reverse: true,
              itemBuilder: (context, index, animation) {
                final reversedIndex = widget.controller.messages.length - 1 - index;
                final message = widget.controller.messages[reversedIndex];
                final isSentByMe = message.authorId == widget.currentUserId;

                // Calculate message grouping
                final groupStatus = _calculateGroupStatus(reversedIndex);

                return switch (message) {
                  TextChatMessage() when isSentByMe => TextMessageBubble.self(
                    message: message,
                    index: reversedIndex,
                    animation: _animationControllers[reversedIndex],
                    groupStatus: groupStatus,
                  ),
                  TextChatMessage() => TextMessageBubble.other(
                    message: message,
                    index: reversedIndex,
                    animation: _animationControllers[reversedIndex],
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
    final messages = widget.controller.messages;
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
      return .middle;
    } else if (isSameAuthorAsPrev) {
      return .last;
    } else if (isSameAuthorAsNext) {
      return .first;
    } else {
      return .single;
    }
  }
}
