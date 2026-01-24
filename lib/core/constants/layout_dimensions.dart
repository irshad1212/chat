import 'package:flutter/material.dart' show Size;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LayoutDimensions {
  static const Size designSize = Size(393.0, 852.0);

  static double get spacingXS => 4.w;
  static double get spacingS => 8.w;
  static double get spacingM => 12.w;
  static double get spacingL => 16.w;
  static double get spacingXL => 20.w;
  static double get spacing2XL => 24.w;
  static double get spacing3XL => 32.w;

  // Vertical Spacing (Height specific)
  static double get spacingVerticalXS => 4.h;
  static double get spacingVerticalS => 8.h;
  static double get spacingVerticalM => 12.h;
  static double get spacingVerticalL => 16.h;
  static double get spacingVerticalXL => 20.h;
  static double get spacingVertical2XL => 24.h;

  // Radii
  static double get radiusXS => 4.r;
  static double get radiusS => 8.r;
  static double get radiusM => 12.r;
  static double get radiusL => 16.r;
  static double get radiusXL => 24.r;
  static double get radiusXXL => 40.r;

  // Icons
  static double get iconSmall => 18.sp;
  static double get iconMedium => 24.sp;
  static double get iconLarge => 32.sp;

  // Specific
  static double get bottomSheetRadius => 24.r;
}
