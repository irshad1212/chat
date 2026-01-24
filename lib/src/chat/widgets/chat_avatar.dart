import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat/core/constants/strings.dart';
import 'package:chat/core/theme/colors.dart';
import 'package:chat/core/theme/text_styles.dart';

class ChatAvatar extends StatelessWidget {
  final bool isOther;

  const ChatAvatar({super.key, required this.isOther});

  @override
  Widget build(BuildContext context) {
    if (isOther) {
      return Container(
        width: 24.r,
        height: 24.r,
        decoration: const BoxDecoration(
          shape: .circle,
          gradient: LinearGradient(
            colors: [AppColors.blueGradientStart, AppColors.blueGradientEnd],
            begin: .topLeft,
            end: .bottomRight,
          ),
        ),
        child: Center(child: Text(Strings.selfInitial, style: TextStyles.inter.chatAvatarInitial)),
      );
    }

    return Container(
      width: 24.r,
      height: 24.r,
      decoration: const BoxDecoration(
        shape: .circle,
        gradient: LinearGradient(
          colors: [AppColors.pinkGradientStart, AppColors.pinkGradientEnd],
          begin: .topLeft,
          end: .bottomRight,
        ),
      ),
      child: Center(child: Text(Strings.selfInitial, style: TextStyles.inter.chatAvatarInitial)),
    );
  }
}
