import 'package:aicp/const/font_family.dart';
import 'package:aicp/themes/app_colors.dart';
import 'package:flutter/material.dart';

class TextStyleTheme {
  static textProfile(context) {
    return TextStyle(
      fontFamily: FontFamily.PromptRegular,
      fontSize: 17,
      color: AppColors.indigoPrimary,
      fontWeight: FontWeight.w500,
    );
  }
}
