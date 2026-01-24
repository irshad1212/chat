import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'package:chat/core/enums/message_group_status.dart';
import 'package:chat/core/theme/colors.dart';
import 'package:chat/core/theme/text_styles.dart';
import 'package:chat/src/chat/models/chat_message.dart';
import 'package:chat/src/dictionary/widgets/word_meaning_bottom_sheet.dart';
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
            padding: .symmetric(horizontal: 14.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              mainAxisAlignment: .center,
              children: [_buildTappableText(context, message.text, true)],
            ),
          ),
          if (message.createdAt != null)
            Padding(
              padding: .only(top: 6.h),
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
          padding: .symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: _buildBorderRadius(isOther: false),
            border: Border.all(color: AppColors.messageBorder),
          ),
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            mainAxisAlignment: .center,
            children: [_buildTappableText(context, message.text, false)],
          ),
        ),
        if (message.createdAt != null)
          Padding(
            padding: .only(top: 4.h),
            child: Text(
              _timeFormatter.format(message.createdAt!),
              style: TextStyles.inter.messageBubbleTime,
            ),
          ),

        if (groupStatus?.isLast ?? false) 8.verticalSpace else 6.verticalSpace,
      ],
    );
  }

  Widget _buildTappableText(BuildContext context, String text, bool isOther) {
    if (!isOther) {
      return GestureDetector(
        onTapDown: (details) {
          final tappedWord = _getWordAtPosition(context, text, details.localPosition, isOther);
          if (tappedWord != null && tappedWord.isNotEmpty) {
            FocusManager.instance.primaryFocus?.unfocus();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => WordMeaningBottomSheet(word: tappedWord),
            );
          }
        },
        child: Text(
          text,
          style: TextStyles.inter.messageBubbleText.copyWith(color: AppColors.white),
        ),
      );
    }

    return Text(
      text,
      style: TextStyles.inter.messageBubbleText.copyWith(color: AppColors.textColor),
    );
  }

  String? _getWordAtPosition(
    BuildContext context,
    String text,
    Offset localPosition,
    bool isOther,
  ) {
    final textStyle = TextStyles.inter.messageBubbleText.copyWith(
      color: isOther ? AppColors.textColor : AppColors.white,
    );

    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);

    textPainter.layout(maxWidth: context.sw() * 0.65 - 28.w);

    final position = textPainter.getPositionForOffset(localPosition);
    final offset = position.offset;

    if (offset < 0 || offset >= text.length) return null;

    int start = offset;
    int end = offset;

    while (start > 0 && text[start - 1].contains(RegExp(r'[a-zA-Z]'))) {
      start--;
    }

    while (end < text.length && text[end].contains(RegExp(r'[a-zA-Z]'))) {
      end++;
    }

    if (start < end) {
      return text.substring(start, end);
    }

    return null;
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
