import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:chat/core/enums/message_group_status.dart';
import 'package:chat/core/theme/colors.dart';
import 'package:chat/core/theme/text_styles.dart';
import 'package:chat/src/chat/models/chat_message.dart';
import 'package:chat/utils/helpers/extensions.dart';

class MessageBubble extends StatelessWidget {
  final TextChatMessage message;
  final bool isOther;
  final MessageGroupStatus? groupStatus;

  static final DateFormat _timeFormatter = DateFormat('hh:mm aa');

  const MessageBubble({super.key, required this.message, required this.isOther, this.groupStatus});

  @override
  Widget build(BuildContext context) {
    if (isOther) {
      return Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .center,
        children: [
          Container(
            constraints: BoxConstraints(
              minWidth: 50.w,
              minHeight: 46.h,
              maxWidth: context.sw() * 0.65,
            ),
            decoration: BoxDecoration(
              color: AppColors.chatBubbleOther,
              borderRadius: _buildBorderRadius(isOther: true),
            ),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              mainAxisAlignment: .center,
              children: [
                Text(
                  message.text,
                  style: TextStyles.inter.messageBubbleText.copyWith(color: AppColors.textColor),
                ),
              ],
            ),
          ),
          if (message.createdAt != null)
            Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Text(
                _timeFormatter.format(message.createdAt!),
                style: TextStyles.inter.messageBubbleTime,
              ),
            ),

          if (groupStatus?.isLast ?? false) 8.verticalSpace else 6.verticalSpace,
        ],
      );
    }

    return Column(
      crossAxisAlignment: .end,
      children: [
        Container(
          constraints: BoxConstraints(
            minWidth: 50.w,
            minHeight: 46.h,
            maxWidth: context.sw() * 0.65,
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: _buildBorderRadius(isOther: false),
            border: Border.all(color: AppColors.messageBorder),
          ),
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            mainAxisAlignment: .center,
            children: [
              Text(
                message.text,
                textAlign: .left,
                style: TextStyles.inter.messageBubbleText.copyWith(color: AppColors.white),
              ),
            ],
          ),
        ),
        if (message.createdAt != null)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              _timeFormatter.format(message.createdAt!),
              style: TextStyles.inter.messageBubbleTime,
            ),
          ),

        if (groupStatus?.isLast ?? false) 8.verticalSpace else 6.verticalSpace,
      ],
    );
  }

  BorderRadius _buildBorderRadius({required bool isOther}) {
    const double radius = 12.0;
    if (isOther) {
      return const BorderRadius.only(
        topLeft: Radius.circular(radius - 6),
        topRight: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
      );
    } else {
      return const BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius - 6),
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      );
    }
  }
}
