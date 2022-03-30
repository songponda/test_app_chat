import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class PushPageTran {
  static push(context, pageName) {
    Navigator.push(
        context,
        PageTransition(
            duration: const Duration(milliseconds: 500),
            type: PageTransitionType.leftToRightWithFade,
            child: pageName));
  }

  static pushReplacement(context, pageName) {
    Navigator.pushReplacement(
        context,
        PageTransition(
            duration: const Duration(milliseconds: 500),
            type: PageTransitionType.leftToRightWithFade,
            child: pageName));
  }
}
