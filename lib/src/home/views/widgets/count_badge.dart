import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat/core/constants/strings.dart';
import 'package:chat/core/theme/colors.dart';
import 'package:chat/core/theme/text_styles.dart';

class CountBadge extends StatelessWidget {
  const CountBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedScale(
        scale: count != 0 ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Container(
          width: 22.r,
          height: 22.r,
          decoration: BoxDecoration(
            shape: .circle,
            color: AppColors.primaryBlue,
            border: Border.all(width: 1.5, color: Colors.white),
          ),
          child: Center(
            child: Text(
              count > 9 ? Strings.plus9 : count.toString(),
              style: TextStyles.inter.countBadge,
            ),
          ),
        ),
      ),
    );
  }
}
