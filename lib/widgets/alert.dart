import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/register_screen.dart';
import 'package:aicp/const/font_family.dart';
import 'package:aicp/screens/index_screen.dart';
import 'package:aicp/themes/app_colors.dart';
import 'package:aicp/widgets/push_page_transition.dart';
import 'package:aicp/widgets/sizebox_widgets.dart';

class Alert {
  static alert1button(context, title, content, actions) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(actions),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  static alert12button(context, title, content, actions) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(actions),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  static popupAlertWarningForRegister(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)), //this right here
              child: SizedBox(
                width: 358,
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    S.h(90.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "alert_register".tr(),
                          style: const TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 15,
                            color: AppColors.black,
                            fontWeight: FontWeight.w800,
                            height: 1.263157894736842,
                          ),
                          textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    S.h(45.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => PushPageTran.push(
                              context, const RegisterScreen()),
                          child: Container(
                              width: 100,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: const Color(0xff022D54),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ok'.tr(),
                                    style: const TextStyle(
                                      fontFamily: 'Prompt',
                                      fontSize: 17,
                                      color: Color(0xffffffff),
                                      letterSpacing: 0.51,
                                      height: 1.3529411764705883,
                                    ),
                                    textHeightBehavior:
                                        const TextHeightBehavior(
                                            applyHeightToFirstAscent: false),
                                    textAlign: TextAlign.left,
                                  )
                                ],
                              )),
                        ),
                        S.w(8.0),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                              width: 100,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: const Color(0xff022D54),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'cancel'.tr(),
                                    style: const TextStyle(
                                      fontFamily: 'Prompt',
                                      fontSize: 17,
                                      color: Color(0xffffffff),
                                      letterSpacing: 0.51,
                                      height: 1.3529411764705883,
                                    ),
                                    textHeightBehavior:
                                        const TextHeightBehavior(
                                            applyHeightToFirstAscent: false),
                                    textAlign: TextAlign.left,
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static popupAlertSuccessEditProfile(String title, context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)), //this right here
              child: SizedBox(
                width: 358,
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    S.h(90.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 16,
                            color: AppColors.black,
                            fontWeight: FontWeight.w800,
                            height: 1.263157894736842,
                          ),
                          textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    S.h(45.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => PushPageTran.pushReplacement(
                              context, const IndexScreen()),
                          child: Container(
                              width: 181,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: const Color(0xff022D54),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'done'.tr(),
                                    style: const TextStyle(
                                      fontFamily: 'Prompt',
                                      fontSize: 17,
                                      color: Color(0xffffffff),
                                      letterSpacing: 0.51,
                                      height: 1.3529411764705883,
                                    ),
                                    textHeightBehavior:
                                        const TextHeightBehavior(
                                            applyHeightToFirstAscent: false),
                                    textAlign: TextAlign.left,
                                  )
                                ],
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  static popupAlertErrorContactAdmin(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)), //this right here
              child: SizedBox(
                width: 358,
                height: 330.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    S.h(90.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.indigoPrimary,
                          size: 50.0,
                        ),
                        S.w(10.0),
                        Text(
                          'alertError'.tr(),
                          style: const TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 15,
                            color: AppColors.black,
                            fontWeight: FontWeight.w800,
                            height: 1.263157894736842,
                          ),
                          textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    S.h(25.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "reachUs".tr(),
                                style: TextStyle(
                                  color: AppColors.red,
                                  fontSize: 16,
                                  fontFamily: FontFamily.PromptBold,
                                ),
                              ),
                              S.h(20.3),
                              InkWell(
                                onTap: () async {
                                  const url =
                                      'https://www.facebook.com/AICPMotor';
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Facebook",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: FontFamily.PromptRegular,
                                          color: AppColors.indigoProfileText),
                                    ),
                                    S.w(26.0),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                          'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Facebook_Logo_%282019%29.png/1200px-Facebook_Logo_%282019%29.png',
                                          fit: BoxFit.cover,
                                          width: 26,
                                          height: 26),
                                    )
                                  ],
                                ),
                              ),
                              S.h(24.0),
                              InkWell(
                                onTap: () async {
                                  const url = 'https://t.me/aicpmotor';
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Telegram",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: FontFamily.PromptRegular,
                                          color: AppColors.indigoProfileText),
                                    ),
                                    S.w(26.0),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                          'https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Telegram_logo.svg/1024px-Telegram_logo.svg.png',
                                          fit: BoxFit.cover,
                                          width: 26,
                                          height: 26),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    S.h(45.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () =>
                              PushPageTran.push(context, const IndexScreen()),
                          child: Container(
                              width: 181,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: const Color(0xff022D54),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ok'.tr(),
                                    style: const TextStyle(
                                      fontFamily: 'Prompt',
                                      fontSize: 17,
                                      color: Color(0xffffffff),
                                      letterSpacing: 0.51,
                                      height: 1.3529411764705883,
                                    ),
                                    textHeightBehavior:
                                        const TextHeightBehavior(
                                            applyHeightToFirstAscent: false),
                                    textAlign: TextAlign.left,
                                  )
                                ],
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  static popupAlertSaveSuccess(String title, context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)), //this right here
              child: SizedBox(
                width: 358,
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    S.h(90.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 16,
                            color: AppColors.black,
                            fontWeight: FontWeight.w800,
                            height: 1.263157894736842,
                          ),
                          textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    S.h(45.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => PushPageTran.pushReplacement(
                              context, const IndexScreen()),
                          child: Container(
                              width: 181,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: const Color(0xff022D54),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ok'.tr(),
                                    style: const TextStyle(
                                      fontFamily: 'Prompt',
                                      fontSize: 17,
                                      color: Color(0xffffffff),
                                      letterSpacing: 0.51,
                                      height: 1.3529411764705883,
                                    ),
                                    textHeightBehavior:
                                        const TextHeightBehavior(
                                            applyHeightToFirstAscent: false),
                                    textAlign: TextAlign.left,
                                  )
                                ],
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
