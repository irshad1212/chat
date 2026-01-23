import 'package:chat/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyles {
  static InterFontPalette get inter => InterFontPalette.instance;
}

class InterFontPalette {
  static InterFontPalette? _instance;

  static InterFontPalette get instance {
    _instance ??= InterFontPalette();
    return _instance!;
  }

  /// Font weights
  ///
  /// Regular     - 400
  /// Medium      - 500
  /// Semi Bold   - 600
  /// Bold        - 700
  /// Extra Bold  - 800
  ///

  /// Common styles
  TextStyle get regular =>
      TextStyle(fontSize: 14.sp, color: AppColors.black, fontWeight: FontWeight.w400);

  TextStyle get medium =>
      TextStyle(fontSize: 14.sp, color: AppColors.black, fontWeight: FontWeight.w500);

  TextStyle get semibold =>
      TextStyle(fontSize: 14.sp, color: AppColors.black, fontWeight: FontWeight.w600);

  TextStyle get bold =>
      TextStyle(fontSize: 14.sp, color: AppColors.black, fontWeight: FontWeight.w700);

  TextStyle get extrabold =>
      TextStyle(fontSize: 14.sp, color: AppColors.black, fontWeight: FontWeight.w800);

  /// Bottom Navigation Bar styles
  TextStyle get bottomNavSelected =>
      TextStyle(fontSize: 12.sp, color: AppColors.black, fontWeight: FontWeight.w600, height: 0);

  TextStyle get bottomNavUnselected => TextStyle(
    fontSize: 12.sp,
    color: AppColors.textColorSecondary,
    fontWeight: FontWeight.w600,
    height: 0,
  );

  /// Chat Tile styles
  TextStyle get chatTileTitle => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
    letterSpacing: 0.5,
  );

  TextStyle get chatTileSubtitle =>
      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColors.textColorSecondary);

  /// Chat App Bar styles
  TextStyle get chatAppBarTitle => TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600);

  TextStyle get chatAppBarSubtitle => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textColorTertiary, // Default, can be overridden
  );

  /// Message Bubble styles
  TextStyle get messageBubbleText => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500);

  TextStyle get messageBubbleTime =>
      TextStyle(fontSize: 12.sp, color: AppColors.textColorTertiary, fontWeight: FontWeight.w500);

  /// Chat Avatar styles
  TextStyle get chatAvatarInitial =>
      TextStyle(fontSize: 10.sp, color: AppColors.white, fontWeight: FontWeight.bold);

  /// Input styles
  TextStyle get inputHint =>
      TextStyle(color: AppColors.textColorTertiary, fontSize: 14.sp, fontWeight: FontWeight.w400);

  TextStyle get inputText =>
      TextStyle(fontSize: 14.sp, color: AppColors.black, fontWeight: FontWeight.w500);

  TextStyle get countBadge =>
      TextStyle(fontSize: 10.sp, color: AppColors.white, fontWeight: FontWeight.bold);
}
