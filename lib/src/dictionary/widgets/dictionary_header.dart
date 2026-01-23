import 'package:chat/core/theme/colors.dart';
import 'package:chat/core/theme/text_styles.dart';
import 'package:chat/src/dictionary/models/word_definition_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DictionaryHeader extends StatelessWidget {
  final WordDefinitionModel definition;

  const DictionaryHeader({super.key, required this.definition});

  @override
  Widget build(BuildContext context) {
    String? phoneticText = definition.phonetic;
    if (phoneticText == null || phoneticText.isEmpty) {
      for (final p in definition.phonetics) {
        if (p.text != null && p.text!.isNotEmpty) {
          phoneticText = p.text;
          break;
        }
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.textColorTertiary.withValues(alpha: 0.2), width: 1.h),
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        children: [
          Text(definition.word, style: TextStyles.inter.dictionaryWord),
          if (phoneticText != null && phoneticText.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(Icons.volume_up, size: 18.sp, color: AppColors.primaryBlue),
                SizedBox(width: 6.w),
                Text(phoneticText, style: TextStyles.inter.dictionaryPhonetic),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
