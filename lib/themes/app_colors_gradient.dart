import 'package:aicp/themes/app_colors.dart';
import 'package:flutter/material.dart';

Gradient bottomNavigationBarGradient = const LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  stops: [0, 1.0],
  colors: [AppColors.indigoLow, AppColors.indigoPrimary],
);

Gradient appBarGradient = const LinearGradient(
  begin: Alignment(0.0, -1.0),
  end: Alignment(0.0, 1.0),
  colors: [Color(0xff305679), Color(0xff032d54)],
  stops: [0.0, 1.0],
);
