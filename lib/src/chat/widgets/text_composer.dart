import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:chat/core/constants/strings.dart';
import 'package:chat/core/theme/colors.dart';
import 'package:chat/core/theme/text_styles.dart';
import 'package:chat/generated/assets.dart';

/// Simple composer for text input
class SimpleTextComposer extends ConsumerStatefulWidget {
  final Function(String) onSend;
  final String? hintText;

  const SimpleTextComposer({super.key, required this.onSend, this.hintText = Strings.typeMessage});

  @override
  ConsumerState<SimpleTextComposer> createState() => _SimpleTextComposerState();
}

class _SimpleTextComposerState extends ConsumerState<SimpleTextComposer> {
  late final TextEditingController _controller;
  late final ValueNotifier<bool> _hasText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _hasText = ValueNotifier(false);
    _controller.addListener(() {
      _hasText.value = _controller.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _hasText.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(color: AppColors.boxShadow, blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.chatBubbleOther,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller,
                cursorColor: AppColors.black,
                cursorHeight: 20.h,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: .none,
                  hintStyle: TextStyles.inter.inputHint,
                ),
                style: TextStyles.inter.inputText,
                maxLines: 5,
                minLines: 1,
                textCapitalization: .sentences,
                onSubmitted: (_) => _handleSend(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ValueListenableBuilder<bool>(
            valueListenable: _hasText,
            builder: (context, hasText, _) {
              return GestureDetector(
                onTap: hasText ? _handleSend : null,
                child: Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: hasText
                        ? AppColors.primaryBlue
                        : AppColors.primaryBlue.withValues(alpha: 0.1),
                    shape: .circle,
                  ),
                  child: Center(
                    child: Transform.translate(
                      offset: const Offset(-2, 0),
                      child: Transform.rotate(
                        angle: 0.7,
                        child: SvgPicture.asset(
                          Assets.svgLogo,
                          height: 22.r,
                          colorFilter: ColorFilter.mode(
                            hasText ? AppColors.white : AppColors.textColorTertiary,
                            .srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
