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
  TextStyle get regular => TextStyle(fontSize: 14.sp, color: AppColors.black, fontWeight: .w400);

  TextStyle get medium => TextStyle(fontSize: 14.sp, color: AppColors.black, fontWeight: .w500);

  TextStyle get semibold => TextStyle(fontSize: 14.sp, color: AppColors.black, fontWeight: .w600);

  TextStyle get bold => TextStyle(fontSize: 14.sp, color: AppColors.black, fontWeight: .w700);

  TextStyle get extrabold => TextStyle(fontSize: 14.sp, color: AppColors.black, fontWeight: .w800);

  /// Bottom Navigation Bar styles
  TextStyle get bottomNavSelected =>
      TextStyle(fontSize: 12.sp, color: AppColors.black, fontWeight: .w600, height: 0);

  TextStyle get bottomNavUnselected =>
      TextStyle(fontSize: 12.sp, color: AppColors.textColorSecondary, fontWeight: .w600, height: 0);

  /// Chat Tile styles
  TextStyle get chatTileTitle =>
      TextStyle(fontSize: 16.sp, fontWeight: .w600, color: AppColors.textColor, letterSpacing: 0.5);

  TextStyle get chatTileSubtitle =>
      TextStyle(fontSize: 13.sp, fontWeight: .w500, color: AppColors.textColorSecondary);

  /// Chat App Bar styles
  TextStyle get chatAppBarTitle => TextStyle(fontSize: 16.sp, fontWeight: .w600);

  TextStyle get chatAppBarSubtitle => TextStyle(
    fontSize: 12.sp,
    fontWeight: .w400,
    color: AppColors.textColorTertiary, // Default, can be overridden
  );

  /// Message Bubble styles
  TextStyle get messageBubbleText => TextStyle(fontSize: 14.sp, fontWeight: .w500);

  TextStyle get messageBubbleTime =>
      TextStyle(fontSize: 12.sp, color: AppColors.textColorTertiary, fontWeight: .w500);

  /// Chat Avatar styles
  TextStyle get chatAvatarInitial =>
      TextStyle(fontSize: 10.sp, color: AppColors.white, fontWeight: .bold);

  /// Input styles
  TextStyle get inputHint =>
      TextStyle(color: AppColors.textColorTertiary, fontSize: 14.sp, fontWeight: .w400);

  TextStyle get inputText => TextStyle(fontSize: 14.sp, color: AppColors.black, fontWeight: .w500);

  TextStyle get countBadge => TextStyle(fontSize: 10.sp, color: AppColors.white, fontWeight: .bold);

  /// Dictionary styles
  TextStyle get dictionaryWord =>
      TextStyle(fontSize: 32.sp, fontWeight: .w800, color: AppColors.black, height: 1.2);

  TextStyle get dictionaryPhonetic =>
      TextStyle(fontSize: 16.sp, fontWeight: .w500, color: AppColors.primaryBlue);

  TextStyle get dictionaryPartOfSpeech =>
      TextStyle(fontSize: 14.sp, fontWeight: .bold, color: AppColors.primaryBlue);

  TextStyle get dictionaryDefinition =>
      TextStyle(fontSize: 15.sp, fontWeight: .w400, color: AppColors.black, height: 1.5);

  TextStyle get dictionaryExampleQuote =>
      TextStyle(fontSize: 18.sp, fontWeight: .bold, color: AppColors.textColorSecondary);

  TextStyle get dictionaryExampleText => TextStyle(
    fontSize: 14.sp,
    fontWeight: .w400,
    fontStyle: FontStyle.italic,
    color: AppColors.textColorSecondary,
    height: 1.4,
  );

  TextStyle get dictionaryIndex =>
      TextStyle(fontSize: 12.sp, fontWeight: .w600, color: AppColors.textColorSecondary);

  TextStyle get dictionaryChipLabel =>
      TextStyle(fontSize: 13.sp, fontWeight: .w600, color: AppColors.textColorSecondary);

  TextStyle get dictionaryChipText =>
      TextStyle(fontSize: 13.sp, fontWeight: .w500); // Color is dynamic

  TextStyle get dictionaryNotFoundTitle =>
      TextStyle(fontSize: 18.sp, fontWeight: .bold, color: AppColors.black);

  TextStyle get dictionaryNotFoundSubtitle =>
      TextStyle(fontSize: 14.sp, fontWeight: .w400, color: AppColors.textColorSecondary);
}
