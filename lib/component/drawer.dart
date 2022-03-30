import 'dart:math';
import 'dart:ui';
import 'package:aicp/const/pref_data.dart';
import 'package:aicp/screens/index_screen.dart';
import 'package:aicp/utils/first_page.dart';
import 'package:aicp/utils/share_pref.dart';
import 'package:aicp/widgets/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aicp/const/font_family.dart';
import 'package:aicp/themes/app_colors.dart';
import 'package:aicp/widgets/sizebox_widgets.dart';
import 'package:aicp/screens/feedback_screen.dart';
import 'package:aicp/screens/term_policies_screen.dart';
import 'package:aicp/service/logout_service.dart';
import 'package:aicp/widgets/push_page_transition.dart';

class Drawers extends StatefulWidget {
  final homeContext;

  const Drawers(this.homeContext, {Key? key}) : super(key: key);

  @override
  _Drawers createState() => _Drawers(homeContext);
}

class _Drawers extends State<Drawers> with SingleTickerProviderStateMixin {
  final homeContext;

  _Drawers(this.homeContext);

//  final formatter = new NumberFormat("#,###,###");

  bool status = true;
  String version = "";
  late String lang;
  late bool registerStatus;

  // var positionXLangBox = 1;
  // var positionYLangBox = 1;
  double heightLangauges = 34;
  double degrees = 90;
  double rotateAngle = 0;
  late final fadeController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 350),
  );

  late final Animation<double> fadeAnime = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(fadeController);

  @override
  void initState() {
    super.initState();
    getVersion();
    checkLanguage();
  }

  @override
  void dispose() {
    fadeController.dispose();
    super.dispose();
  }

  getVersion() async {
    var showVersion = await getCurrentVersion();

    setState(() {
      version = showVersion;
    });
  }

  /// Get version in code
  static getCurrentVersion() async {
    PackageInfo packageInfo;
    packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    // print(version);

    return version;
  }

  Future<dynamic> checkLanguage() async {
    lang = await SharedPref.readValue('string', Preferences.languageStatus);
    // print('lang = $lang');

    return true;
  }

  checkBeforeSendFeedback() async {
    registerStatus =
        await SharedPref.readValue('bool', Preferences.registerStatus);

    if (registerStatus == true) {
      PushPageTran.push(context, const FeedbackScreen());
    } else {
      Alert.popupAlertWarningForRegister(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        height: 926,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.indigoLow, AppColors.indigoPrimary],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 23.8, right: 23.8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                S.h(83.0),
                Text(
                  'language'.tr(),
                  style: TextStyle(
                    fontFamily: FontFamily.PromptMedium,
                    fontSize: 17,
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                ),
                S.h(10.0),
                SizedBox(
                  height: 70,
                  child: Stack(
                    children: [
                      Container(
                        height: 34,
                      ),
                      Positioned(
                        top: 46,
                        child: Text(
                          "notify".tr(),
                          style: TextStyle(
                            fontFamily: FontFamily.PromptRegular,
                            fontSize: 17,
                            color: AppColors.white,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: InkWell(
                          onTap: () {
                            if (heightLangauges == 34) {
                              heightLangauges = 68;
                              rotateAngle = 90 * pi / 180;
                              setState(() {});
                              fadeController.forward();
                            } else {
                              heightLangauges = 34;
                              rotateAngle = 0;
                              setState(() {});
                              fadeController.reset();
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: heightLangauges,
                            width: 108,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: const Color(0xffe8e8e8),
                            ),
                            child: Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 7, left: 12.75, right: 12.75),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "firstTextLang".tr(),
                                      style: const TextStyle(
                                        fontFamily: 'Sukhumvit Set',
                                        fontSize: 17,
                                        color: Color(0xff345776),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    S.w(14.0),
                                    Transform.rotate(
                                      angle: rotateAngle,
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColors.indigoProfile,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 38.5,
                          left: 12.75,
                          child: InkWell(
                            onTap: () async {
                              heightLangauges = 34;
                              rotateAngle = 0;
                              setState(() {});
                              fadeController.reset();
                              if (lang == 'en' || lang == null) {
                                await context
                                    .setLocale(const Locale('km', 'KM'));

                                Future.delayed(
                                    const Duration(milliseconds: 500),
                                    () async {
                                  await SharedPref.setValue('string',
                                      Preferences.languageStatus, 'km');
                                  AppFirstPage.makeFirst(
                                      context, const IndexScreen());
                                });
                              } else {
                                await context
                                    .setLocale(const Locale('en', 'US'));

                                Future.delayed(
                                    const Duration(milliseconds: 500),
                                    () async {
                                  await SharedPref.setValue('string',
                                      Preferences.languageStatus, 'en');
                                  AppFirstPage.makeFirst(
                                      context, const IndexScreen());
                                });
                              }
                            },
                            child: FadeTransition(
                              opacity: fadeAnime,
                              child: Container(
                                width: 90,
                                child: Text(
                                  "secondTextLang".tr(),
                                  style: const TextStyle(
                                    fontFamily: 'Sukhumvit Set',
                                    fontSize: 17,
                                    color: Color(0xff345776),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                S.h(14.0),
                Switch(
                  value: status,
                  onChanged: (value) {
                    print("VALUE : $value");
                    setState(() {
                      status = value;
                    });
                  },
                  activeTrackColor: AppColors.white,
                  inactiveThumbColor: const Color(0xff707070),
                  activeColor: AppColors.indigoProfile,
                  inactiveTrackColor: const Color(0xff929194),
                ),
                S.h(98.0),
                InkWell(
                  onTap: () => displayDialog(),
                  child: _buildTextMenu(context, 'logout'.tr()),
                ),
                S.h(16.7),
                _buildDivider(),
                S.h(16.7),
                InkWell(
                  onTap: () {
                    checkBeforeSendFeedback();
                  },
                  child: _buildTextMenu(context, 'feedback'.tr()),
                ),
                S.h(22.0),
                InkWell(
                    onTap: () =>
                        PushPageTran.push(context, const TermPoliciesScreen()),
                    child: _buildTextMenu(context, 'term_policies'.tr())),
                S.h(22.0),
                // _buildTextMenu(context, 'About Us'),
                S.h(180.0),
                _buildVersionNumber()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void displayDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text("alert_logout".tr()),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("cancel".tr()),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("confirm".tr()),
            onPressed: () async {
              LogoutService.logout(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.1),
      child: Divider(
        color: AppColors.white.withOpacity(0.4),
      ),
    );
  }

  Widget _buildVersionNumber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'version'.tr(),
          style: const TextStyle(
            fontFamily: 'Prompt',
            fontSize: 15,
            color: Color(0xbfffffff),
            letterSpacing: 0.75,
            height: 2.2666666666666666,
          ),
          textHeightBehavior:
              const TextHeightBehavior(applyHeightToFirstAscent: false),
          textAlign: TextAlign.left,
        ),
        Text(
          version,
          style: const TextStyle(
            fontFamily: 'Prompt',
            fontSize: 15,
            color: Color(0xbfffffff),
            letterSpacing: 0.75,
            height: 2.2666666666666666,
          ),
          textHeightBehavior:
              const TextHeightBehavior(applyHeightToFirstAscent: false),
          textAlign: TextAlign.right,
        )
      ],
    );
  }
}

_buildTextMenu(context, String msg) {
  return Text(
    msg,
    style: TextStyle(
      fontFamily: FontFamily.PromptRegular,
      fontSize: 17,
      color: AppColors.white,
    ),
    textAlign: TextAlign.left,
  );
}
