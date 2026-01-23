import 'package:chat/core/constants/app_configs.dart';
import 'package:chat/core/theme/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: AppColors.materialPrimary,
    primarySwatch: AppColors.materialPrimary,
    fontFamily: AppConfigs.fontFamily,
    brightness: Brightness.light,
  );
}
