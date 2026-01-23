import 'package:chat/core/constants/layout_dimensions.dart';
import 'package:chat/core/constants/strings.dart';
import 'package:chat/core/theme/colors.dart';
import 'package:chat/core/theme/text_styles.dart';
import 'package:chat/src/dictionary/models/word_definition_model.dart';
import 'package:chat/src/dictionary/widgets/definition_item.dart';
import 'package:chat/src/dictionary/widgets/word_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MeaningItem extends StatelessWidget {
  final MeaningModel meaning;
  final bool isLast;

  const MeaningItem({super.key, required this.meaning, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 28.h),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          // Part of speech badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: LayoutDimensions.spacingM, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(meaning.partOfSpeech, style: TextStyles.inter.dictionaryPartOfSpeech),
          ),

          SizedBox(height: LayoutDimensions.spacingVerticalL),

          // Definitions
          ...meaning.definitions.asMap().entries.map((entry) {
            return DefinitionItem(index: entry.key + 1, definition: entry.value);
          }),

          // Synonyms
          if (meaning.synonyms.isNotEmpty) ...[
            SizedBox(height: LayoutDimensions.spacingVerticalM),
            WordChips(
              label: Strings.synonyms,
              words: meaning.synonyms,
              color: AppColors.primaryBlue,
            ),
          ],

          // Antonyms
          if (meaning.antonyms.isNotEmpty) ...[
            SizedBox(height: LayoutDimensions.spacingVerticalM),
            WordChips(
              label: Strings.antonyms,
              words: meaning.antonyms,
              color: AppColors.antonymRed,
            ),
          ],
        ],
      ),
    );
  }
}
