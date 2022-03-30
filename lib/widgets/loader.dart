import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:aicp/themes/app_colors.dart';

class Loader {
  static show(context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Center(
                      child: SizedBox(
                        width: 200.h,
                        child: const LoadingIndicator(
                          indicatorType: Indicator.ballClipRotate,
                          colors: [AppColors.indigoPrimary],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static hide(context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static showError(msg) {
    EasyLoading.showError(msg);
  }

  static showSuccess(msg) {
    EasyLoading.showSuccess(msg);
  }

  static showInfo(msg) {
    EasyLoading.showInfo(msg);
  }

  static loadSpin() {
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: SpinKitThreeBounce(
          color: AppColors.indigoPrimary,
          size: 45.0,
        ),
      ),
    );
  }
}
