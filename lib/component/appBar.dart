import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aicp/themes/app_images.dart';
import 'package:aicp/themes/app_colors_gradient.dart';

headerAppBar(context) {
  return Container(
    decoration: const BoxDecoration(),
    height: 100,
    child: Container(
      child: Center(
          child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SvgPicture.asset(
              ImagesThemes.appLogo,
              height: 33.25,
              width: 102.21,
            ),
          ],
        ),
      )),
      decoration: BoxDecoration(
        gradient: appBarGradient,
        // borderRadius: const BorderRadius.only(
        //   bottomLeft: Radius.circular(20.0),
        // ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            offset: Offset(0, 3),
            blurRadius: 10,
          ),
        ],
      ),
    ),
  );
}
