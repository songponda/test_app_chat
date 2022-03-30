import 'package:aicp/themes/app_colors.dart';
import 'package:flutter/material.dart';

class Button {
  static backPopPage(context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: const SizedBox(
        height: 65,
        width: 95,
        child: Icon(
          Icons.arrow_back_ios,
          color: AppColors.white,
          size: 24,
        ),
      ),
    );
  }
}
