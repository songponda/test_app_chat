import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenAppService {
  static openAppLikeWallet() async {
    String os = Platform.operatingSystem;

    if (os == "ios") {
      // print("Container clicked");
      try {
        await launch("likewallet://");
      } on PlatformException catch (e) {
        OpenAppstore.launch(
            androidAppId: "likewallet.likewallet", iOSAppId: "1492241404");
      } finally {
        await launch("likewallet://");
        OpenAppstore.launch(
            androidAppId: "likewallet.likewallet", iOSAppId: "1492241404");
      }
    } else if (os == "android") {
      try {
        await AppAvailability.launchApp("likewallet.likewallet");
      } catch (e) {
        const url =
            'https://play.google.com/store/apps/details?id=likewallet.likewallet&hl=en';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      }
    } else {
      Fluttertoast.showToast(
          msg: "device not support",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  static openAppLDX() async {
    String os = Platform.operatingSystem;

    if (os == "ios") {
      // print("Container clicked");
      try {
        await launch("ldx://");
      } on PlatformException catch (e) {
        OpenAppstore.launch(
            androidAppId: "com.prachakij.ldx", iOSAppId: "1504852835");
      } finally {
        await launch("ldx://");
        OpenAppstore.launch(
            androidAppId: "com.prachakij.ldx", iOSAppId: "1504852835");
      }
    } else if (os == "android") {
      try {
        await AppAvailability.launchApp("com.prachakij.ldx");
      } catch (e) {
        const url =
            'https://play.google.com/store/apps/details?id=com.prachakij.ldx&hl=en_US';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      }
    } else {
      Fluttertoast.showToast(
          msg: "device not support",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }
}
