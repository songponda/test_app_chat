import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppFirstPage {
  static void makeFirst(BuildContext context, page) {
    Navigator.of(context).popUntil((predicate) => predicate.isFirst);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => page,
    ));
  }
}
