import 'package:aicp/screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:aicp/screens/home_screen.dart';
import 'package:aicp/screens/notification_screen.dart';

class Routes {
  Routes._();

  ///static variables
  static const String home = '/home';
  static const String notification = '/notification';
  static const String otp = '/otp';

  /// static final routes
  static final routes = <String, WidgetBuilder>{
    home: (BuildContext context) => const HomeScreen(),
    notification: (BuildContext context) => const NotificationScreen(),
    otp: (BuildContext context) => const OTPScreen(),
  };
}
