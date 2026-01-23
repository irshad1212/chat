import 'package:chat/core/theme/colors.dart';
import 'package:chat/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WordChips extends StatelessWidget {
  final String label;
  final List<String> words;
  final Color color;

  const WordChips({super.key, required this.label, required this.words, required this.color});

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          label,
          style: TextStyles.inter.semibold.copyWith(
            fontSize: 13.sp,
            color: AppColors.textColorSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: words.take(6).map((word) {
            return Container(
              padding: .symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: .circular(6.r),
                border: Border.all(color: color.withValues(alpha: 0.2)),
              ),
              child: Text(word, style: TextStyles.inter.dictionaryChipText.copyWith(color: color)),
            );
          }).toList(),
        ),
      ],
    );
  }
}
