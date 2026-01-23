import 'package:chat/core/constants/layout_dimensions.dart';
import 'package:chat/core/constants/strings.dart';
import 'package:chat/core/theme/colors.dart';
import 'package:chat/core/theme/text_styles.dart';
import 'package:chat/src/dictionary/models/word_definition_model.dart';
import 'package:chat/src/dictionary/widgets/word_chips.dart';
import 'package:flutter/material.dart';

class DefinitionItem extends StatelessWidget {
  final int index;
  final DefinitionModel definition;

  const DefinitionItem({super.key, required this.index, required this.definition});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: LayoutDimensions.spacingVerticalL),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Container(
            width: LayoutDimensions.spacing2XL,
            height: LayoutDimensions.spacing2XL,
            alignment: .center,
            decoration: BoxDecoration(
              color: AppColors.textColorTertiary.withValues(alpha: 0.1),
              shape: .circle,
            ),
            child: Text('$index', style: TextStyles.inter.dictionaryIndex),
          ),
          SizedBox(width: LayoutDimensions.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(definition.definition, style: TextStyles.inter.dictionaryDefinition),
                if (definition.example != null) ...[
                  SizedBox(height: LayoutDimensions.spacingVerticalS),
                  Container(
                    padding: EdgeInsets.all(LayoutDimensions.spacingM),
                    decoration: BoxDecoration(
                      color: AppColors.textColorTertiary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(LayoutDimensions.radiusS),
                      border: Border.all(color: AppColors.textColorTertiary.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      crossAxisAlignment: .start,
                      children: [
                        Text('"', style: TextStyles.inter.dictionaryExampleQuote),
                        SizedBox(width: LayoutDimensions.spacingXS),
                        Expanded(
                          child: Text(
                            definition.example!,
                            style: TextStyles.inter.dictionaryExampleText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                // Synonyms for definition
                if (definition.synonyms.isNotEmpty) ...[
                  SizedBox(height: LayoutDimensions.spacingVerticalS),
                  WordChips(
                    label: Strings.synonyms,
                    words: definition.synonyms,
                    color: AppColors.primaryBlue,
                  ),
                ],
                // Antonyms for definition
                if (definition.antonyms.isNotEmpty) ...[
                  SizedBox(height: LayoutDimensions.spacingVerticalS),
                  WordChips(
                    label: Strings.antonyms,
                    words: definition.antonyms,
                    color: AppColors.antonymRed,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
