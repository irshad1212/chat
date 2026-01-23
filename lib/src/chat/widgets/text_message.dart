import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat/core/enums/message_group_status.dart';
import 'package:chat/core/enums/message_owner.dart';
import 'package:chat/src/chat/models/chat_message.dart';
import 'package:chat/src/chat/widgets/chat_avatar.dart';
import 'package:chat/src/chat/widgets/message_bubble.dart';

/// Standalone text message widget matching City Bees UI style
/// Other: Yellow bubble with admin icon (Admin)
/// Self: White bubble with user initials (User)
class TextMessageBubble extends StatelessWidget {
  final TextChatMessage message;
  final int index;
  final Animation<double> animation;
  final MessageOwner owner;
  final MessageGroupStatus? groupStatus;

  const TextMessageBubble._({
    required this.message,
    required this.index,
    required this.animation,
    required this.owner,
    this.groupStatus,
  });

  factory TextMessageBubble.self({
    required TextChatMessage message,
    required int index,
    required Animation<double> animation,
    MessageGroupStatus? groupStatus,
  }) {
    return TextMessageBubble._(
      message: message,
      index: index,
      animation: animation,
      owner: .self,
      groupStatus: groupStatus,
    );
  }

  factory TextMessageBubble.other({
    required TextChatMessage message,
    required int index,
    required Animation<double> animation,
    MessageGroupStatus? groupStatus,
  }) {
    return TextMessageBubble._(
      message: message,
      index: index,
      animation: animation,
      owner: .other,
      groupStatus: groupStatus,
    );
  }

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.linearToEaseOut);

    // Grouping padding logic
    EdgeInsets padding;
    if (index == 0) {
      padding = const .symmetric(horizontal: 8);
    } else {
      padding = (groupStatus?.isFirst ?? true)
          ? const .fromLTRB(8, 12, 8, 0)
          : const .fromLTRB(8, 2, 8, 0);
    }

    return AnimatedPadding(
      padding: padding,
      duration: const Duration(milliseconds: 250),
      curve: Curves.linearToEaseOut,
      child: FadeTransition(
        opacity: curvedAnimation,
        child: SizeTransition(
          sizeFactor: curvedAnimation,
          child: ScaleTransition(
            scale: curvedAnimation,
            alignment: owner == .self ? .centerRight : .centerLeft,
            child: Align(
              alignment: owner == .self ? .centerRight : .centerLeft,
              child: switch (owner) {
                .self => Row(
                  mainAxisAlignment: .end,
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    MessageBubble(message: message, isOther: false, groupStatus: groupStatus),
                    const SizedBox(width: 6),
                    const ChatAvatar(isOther: false),
                    10.horizontalSpace,
                  ],
                ),
                .other => Row(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    10.horizontalSpace,
                    const ChatAvatar(isOther: true),
                    const SizedBox(width: 6),
                    MessageBubble(message: message, isOther: true, groupStatus: groupStatus),
                  ],
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}
