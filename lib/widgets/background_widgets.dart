import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aicp/themes/app_images.dart';

class Background {
  static imageBgSplash(context) {
    return SvgPicture.asset(
      ImagesThemes.bgLoading,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    );
  }

  static imageLogoAppSplash(context) {
    return SvgPicture.asset(
      ImagesThemes.appLogo,
      height: 64.28,
      width: 197.6,
    );
  }
}
