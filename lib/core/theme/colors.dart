import 'package:flutter/material.dart';

class AppColors {
  static const Color black = Color(0xFF000000);

  static const Color white = Color(0xFFFFFFFF);

  static const Color primaryBlue = Color(0xFF165DFC);

  /// Blue gradient
  static const Color blueGradientStart = Color(0xFF5478FF);
  static const Color blueGradientEnd = Color(0xFF9F55FF);

  /// Pink gradient
  static const Color pinkGradientStart = Color(0xFFBA4AF3);
  static const Color pinkGradientEnd = Color(0xFFE740B2);

  /// Green gradient
  static const Color greenGradientStart = Color(0xFF00C764);
  static const Color greenGradientEnd = Color(0xFF00BF98);

  /// Chat bubble
  static const Color chatBubbleOther = Color(0xFFF3F4F6);
  static const Color chatBubbleSelf = Color(0xFF165DFC);

  /// Text color
  static const Color textColor = Color(0xFF000000);
  static const Color textColorSecondary = Color(0xFF4A5565);
  static const Color textColorTertiary = Color(0xFF6B7282);

  /// Material Primary
  static const MaterialColor materialPrimary = MaterialColor(0xFF165DFC, <int, Color>{
    50: AppColors.primaryBlue,
    100: AppColors.primaryBlue,
    200: AppColors.primaryBlue,
    300: AppColors.primaryBlue,
    400: AppColors.primaryBlue,
    500: AppColors.primaryBlue,
    600: AppColors.primaryBlue,
    700: AppColors.primaryBlue,
    800: AppColors.primaryBlue,
    900: AppColors.primaryBlue,
  });

  /// Border colors
  static const Color borderGrey = Color(0xFFE7E7E7);
}
