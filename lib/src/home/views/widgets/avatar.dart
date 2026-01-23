import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat/core/theme/colors.dart';
import 'package:chat/src/home/models/chat_tile_args.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.args});

  final ChatTileArgs args;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48.r,
      height: 48.r,
      child: Stack(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              shape: .circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: args.type == .user
                    ? [AppColors.blueGradientStart, AppColors.blueGradientEnd]
                    : [AppColors.greenGradientStart, AppColors.greenGradientEnd],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: RepaintBoundary(
              child: AnimatedScale(
                scale: args.isOnline ?? false ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: .circle,
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
