import 'package:chat/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat/core/theme/colors.dart';
import 'package:chat/src/home/models/chat_tile_model.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.model});

  final ChatTileModel model;

  @override
  Widget build(BuildContext context) {
    final isUser = model is UserTileModel;
    final isOnline = isUser ? (model as UserTileModel).isOnline : false;

    return SizedBox(
      width: 48.r,
      height: 48.r,
      child: Stack(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isUser
                    ? [AppColors.blueGradientStart, AppColors.blueGradientEnd]
                    : [AppColors.greenGradientStart, AppColors.greenGradientEnd],
              ),
            ),
            child: Center(
              child: Text(
                model.fullName?.substring(0, 1) ?? '',
                style: TextStyles.inter.chatTileTitle.copyWith(
                  color: AppColors.white,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: RepaintBoundary(
              child: AnimatedScale(
                scale: isOnline ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.green,
                    border: Border.all(width: 1.5, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
