import 'package:chat/core/theme/colors.dart';
import 'package:chat/core/theme/text_styles.dart';
import 'package:chat/src/dictionary/models/word_definition_model.dart';
import 'package:chat/src/dictionary/repository/dictionary_repository_provider.dart';
import 'package:chat/utils/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remote_client/remote_client.dart';

class WordMeaningBottomSheet extends ConsumerWidget {
  final String word;

  const WordMeaningBottomSheet({super.key, required this.word});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: context.sw(),
      height: context.sh(),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
            decoration: BoxDecoration(
              color: AppColors.textColorTertiary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          Expanded(
            child: FutureBuilder<Either<Failure, WordDefinitionModel>>(
              future: ref.read(dictionaryRepositoryProvider).getWordDefinition(word),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: AppColors.primaryBlue),
                      SizedBox(height: 16.h),
                      Text('Loading...', style: TextStyles.inter.medium),
                    ],
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: Text('Error loading definition', style: TextStyles.inter.regular),
                  );
                }

                return snapshot.data!.fold(
                  (failure) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.r),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 48.sp, color: AppColors.textColorTertiary),
                          SizedBox(height: 16.h),
                          Text(
                            'No definition found',
                            style: TextStyles.inter.bold.copyWith(fontSize: 18.sp),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Try searching for another word',
                            style: TextStyles.inter.regular.copyWith(
                              color: AppColors.textColorSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  (definition) => _buildDefinitionContent(definition),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefinitionContent(WordDefinitionModel definition) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Word header with phonetic
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                definition.word,
                style: TextStyles.inter.extrabold.copyWith(fontSize: 32.sp, height: 1.2),
              ),
              6.verticalSpace,
              if (definition.phonetic != null || definition.phonetics.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(Icons.volume_up, size: 18.sp, color: AppColors.primaryBlue),
                    SizedBox(width: 6.w),
                    Text(
                      definition.phonetic ?? definition.phonetics.first.text ?? '',
                      style: TextStyles.inter.medium.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),

          12.verticalSpace,

          // Divider
          Container(height: 1.h, color: AppColors.textColorTertiary.withValues(alpha: 0.2)),

          SizedBox(height: 20.h),

          // Meanings
          ...definition.meanings.asMap().entries.map((entry) {
            final isLast = entry.key == definition.meanings.length - 1;
            return _buildMeaning(entry.value, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildMeaning(MeaningModel meaning, bool isLast) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Part of speech badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              meaning.partOfSpeech,
              style: TextStyles.inter.bold.copyWith(fontSize: 14.sp, color: AppColors.primaryBlue),
            ),
          ),

          SizedBox(height: 16.h),

          // Definitions
          ...meaning.definitions.asMap().entries.map((entry) {
            return _buildDefinition(entry.key + 1, entry.value);
          }),

          // Synonyms
          if (meaning.synonyms.isNotEmpty) ...[
            SizedBox(height: 12.h),
            _buildWordChips('Synonyms', meaning.synonyms, AppColors.primaryBlue),
          ],

          // Antonyms
          if (meaning.antonyms.isNotEmpty) ...[
            SizedBox(height: 12.h),
            _buildWordChips('Antonyms', meaning.antonyms, Colors.red.shade400),
          ],
        ],
      ),
    );
  }

  Widget _buildDefinition(int index, DefinitionModel definition) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.textColorTertiary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$index',
                  style: TextStyles.inter.semibold.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.textColorSecondary,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      definition.definition,
                      style: TextStyles.inter.regular.copyWith(fontSize: 15.sp, height: 1.5),
                    ),
                    if (definition.example != null) ...[
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: AppColors.textColorTertiary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.textColorTertiary.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '"',
                              style: TextStyles.inter.bold.copyWith(
                                fontSize: 18.sp,
                                color: AppColors.textColorSecondary,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                definition.example!,
                                style: TextStyles.inter.regular.copyWith(
                                  fontSize: 14.sp,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.textColorSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWordChips(String label, List<String> words, Color color) {
    if (words.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: color.withValues(alpha: 0.2)),
              ),
              child: Text(
                word,
                style: TextStyles.inter.medium.copyWith(fontSize: 13.sp, color: color),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
