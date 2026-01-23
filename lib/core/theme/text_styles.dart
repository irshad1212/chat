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
}
