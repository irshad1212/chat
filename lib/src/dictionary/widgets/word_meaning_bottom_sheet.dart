import 'package:chat/core/constants/strings.dart';
import 'package:chat/core/theme/colors.dart';
import 'package:chat/core/theme/text_styles.dart';
import 'package:chat/src/dictionary/models/word_definition_model.dart';
import 'package:chat/src/dictionary/repository/dictionary_repository_provider.dart';
import 'package:chat/src/dictionary/widgets/dictionary_header.dart';
import 'package:chat/src/dictionary/widgets/meaning_item.dart';
import 'package:chat/src/shared/widgets/slide_fade_transition.dart';
import 'package:chat/utils/helpers/extensions.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remote_client/remote_client.dart';

class WordMeaningBottomSheet extends ConsumerStatefulWidget {
  final String word;

  const WordMeaningBottomSheet({super.key, required this.word});

  @override
  ConsumerState<WordMeaningBottomSheet> createState() => _WordMeaningBottomSheetState();
}

class _WordMeaningBottomSheetState extends ConsumerState<WordMeaningBottomSheet> {
  late Future<Either<Failure, WordDefinitionModel>> _definitionFuture;

  @override
  void initState() {
    super.initState();
    _definitionFuture = ref.read(dictionaryRepositoryProvider).getWordDefinition(widget.word);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: context.sw(),
        height: context.sh(),
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: .circular(24.r)),
        ),
        child: Column(
          mainAxisSize: .min,
          children: [
            // Drag handle
            Container(
              width: 40.w,
              height: 4.h,
              margin: .only(top: 12.h, bottom: 8.h),
              decoration: BoxDecoration(
                color: AppColors.textColorTertiary.withValues(alpha: 0.3),
                borderRadius: .circular(2.r),
              ),
            ),

            Expanded(
              child: FutureBuilder<Either<Failure, WordDefinitionModel>>(
                future: _definitionFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == .waiting) {
                    return _buildLoadingState();
                  }

                  if (!snapshot.hasData) {
                    return _buildErrorState();
                  }

                  return snapshot.data!.fold(
                    (failure) => _buildNotFoundState(),
                    (definition) => _buildContent(definition),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: .center,
      children: [
        const CircularProgressIndicator(color: AppColors.primaryBlue),
        SizedBox(height: 16.h),
        Text(Strings.loading, style: TextStyles.inter.medium),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(child: Text(Strings.errorLoadingDefinition, style: TextStyles.inter.regular));
  }

  Widget _buildNotFoundState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Icon(Icons.search_off, size: 48.sp, color: AppColors.textColorTertiary),
            SizedBox(height: 16.h),
            Text(Strings.noDefinitionFound, style: TextStyles.inter.dictionaryNotFoundTitle),
            SizedBox(height: 8.h),
            Text(
              Strings.trySearchingAnotherWord,
              style: TextStyles.inter.dictionaryNotFoundSubtitle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(WordDefinitionModel definition) {
    return SlideFadeTransition(
      slideOffset: 4,
      slideDuration: const Duration(milliseconds: 250),
      child: Column(
        children: [
          // Sticky header
          DictionaryHeader(definition: definition),

          // Scrollable meanings
          Expanded(
            child: SingleChildScrollView(
              padding: .symmetric(horizontal: 24.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: .start,
                children: definition.meanings.asMap().entries.map((entry) {
                  final isLast = entry.key == definition.meanings.length - 1;
                  return MeaningItem(meaning: entry.value, isLast: isLast);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
