import 'dart:math';
import 'package:aicp/const/pref_data.dart';
import 'package:aicp/utils/first_page.dart';
import 'package:aicp/utils/share_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:aicp/themes/app_colors.dart';
import 'package:aicp/widgets/background_widgets.dart';
import 'package:aicp/widgets/sizebox_widgets.dart';
import 'package:aicp/const/font_family.dart';
import 'package:aicp/utils/device_utils.dart';
import 'package:aicp/provider/login_provider.dart';

class LoginPhoneScreen extends StatefulWidget {
  const LoginPhoneScreen({Key? key}) : super(key: key);

  @override
  _LoginPhoneScreenState createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  String initialCountry = 'KH';
  PhoneNumber number = PhoneNumber(isoCode: 'KH');
  late LoginProvider loginProvider;
  late String lang;
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

  String version = "";

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'KH');

    setState(() {
      this.number = number;
    });
  }

  Future<dynamic> checkLanguage() async {
    lang = await SharedPref.readValue('string', Preferences.languageStatus);
    print('lang = $lang');

    return true;
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    deleteData();
    checkLanguage();
    getVersion();
  }

  void deleteData() async {
    const storage = FlutterSecureStorage();
    // Delete all
    await storage.deleteAll();
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => DeviceUtils.focusScopeNode(context),
      child: Scaffold(
        body: Consumer<LoginProvider>(
            builder: (context, login, child) => Stack(
                  children: [
                    Background.imageBgSplash(context),
                    Scaffold(
                        backgroundColor:
                            AppColors.indigoPrimary.withOpacity(0.85),
                        body: SingleChildScrollView(
                          child: Stack(
                            children: [
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   children: [
                              //     Padding(
                              //       padding: const EdgeInsets.only(
                              //           top: 65, right: 27),
                              //       child: Container(
                              //         height: 34,
                              //         width: 89,
                              //         decoration: BoxDecoration(
                              //           borderRadius:
                              //               BorderRadius.circular(16.0),
                              //           color: const Color(0xffe8e8e8),
                              //         ),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.center,
                              //           children: [
                              //             const Text(
                              //               'ENG',
                              //               style: TextStyle(
                              //                 fontSize: 16,
                              //                 color: Color(0xff345776),
                              //                 fontWeight: FontWeight.w700,
                              //               ),
                              //             ),
                              //             S.w(13.0),
                              //
                              //             /// icon arrow down
                              //             SvgPicture.string(
                              //               '<svg viewBox="65.5 13.1 11.5 7.2" ><path transform="matrix(-0.017452, 0.999848, -0.999848, -0.017452, 76.98, 13.28)" d="M 1.339263916015625 0 L 0 1.339266300201416 L 4.350238800048828 5.699003219604492 L 0 10.05874061584473 L 1.339263916015625 11.39800643920898 L 7.038266181945801 5.699003219604492 L 1.339263916015625 0 Z" fill="#345776" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                              //               allowDrawingOutsideViewBox: true,
                              //               fit: BoxFit.fill,
                              //             )
                              //           ],
                              //         ),
                              //       ),
                              //     )
                              //   ],
                              // ),
                              Positioned(
                                top: 90,
                                right: 20,
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
                                  top: 124,
                                  right: 24,
                                  child: InkWell(
                                    onTap: () async {
                                      heightLangauges = 34;
                                      rotateAngle = 0;
                                      setState(() {});
                                      fadeController.reset();
                                      if (lang == 'en' || lang == null) {
                                        await context.setLocale(
                                            const Locale('km', 'KM'));

                                        Future.delayed(
                                            const Duration(milliseconds: 500),
                                            () async {
                                          await SharedPref.setValue('string',
                                              Preferences.languageStatus, 'km');
                                          AppFirstPage.makeFirst(context,
                                              const LoginPhoneScreen());
                                        });
                                      } else {
                                        await context.setLocale(
                                            const Locale('en', 'US'));
                                        Future.delayed(
                                            const Duration(milliseconds: 500),
                                            () async {
                                          await SharedPref.setValue('string',
                                              Preferences.languageStatus, 'en');
                                          AppFirstPage.makeFirst(context,
                                              const LoginPhoneScreen());
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
                                  )),
                              Padding(
                                padding: EdgeInsets.only(top: 240.h),
                                child: Column(children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child:
                                        Background.imageLogoAppSplash(context),
                                  ),
                                  S.h(90.0),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 27.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "phoneNumber".tr(),
                                          style: TextStyle(
                                              fontFamily:
                                                  FontFamily.PromptRegular,
                                              fontSize: 18,
                                              color: AppColors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(28.0),
                                      child: Form(
                                        key: formKey,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            InternationalPhoneNumberInput(
                                              inputDecoration: InputDecoration(
                                                hintText: 'Phone Number',
                                                hintStyle: TextStyle(
                                                    color: AppColors.white
                                                        .withOpacity(0.7)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    13.h,
                                                  ),
                                                  borderSide: const BorderSide(
                                                    color: AppColors.red,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    13.h,
                                                  ),
                                                  borderSide: const BorderSide(
                                                    color: AppColors.white,
                                                  ),
                                                ),
                                                border:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: AppColors.white),
                                                ),
                                              ),
                                              maxLength: 11,
                                              countries: const ['KH', 'TH'],
                                              onInputChanged:
                                                  (PhoneNumber number) {
                                                // debugPrint(number.phoneNumber);
                                                login.setPhone(
                                                    _phoneNumberController
                                                        .text);
                                                login.setPhoneNationCode(number
                                                    .phoneNumber
                                                    .toString());
                                              },
                                              onInputValidated: (bool value) {
                                                // print(value);
                                              },
                                              selectorConfig:
                                                  const SelectorConfig(
                                                selectorType:
                                                    PhoneInputSelectorType
                                                        .BOTTOM_SHEET,
                                              ),
                                              ignoreBlank: false,
                                              errorMessage:
                                                  'Invalid phone number',
                                              cursorColor: AppColors.white,
                                              autoValidateMode:
                                                  AutovalidateMode.disabled,
                                              // hintText: 'Phone Mobile',
                                              textStyle: const TextStyle(
                                                  color: Colors.white),
                                              selectorTextStyle:
                                                  const TextStyle(
                                                      color: Colors.white),
                                              initialValue: number,
                                              textFieldController:
                                                  _phoneNumberController,
                                              formatInput: false,
                                              keyboardType: const TextInputType
                                                      .numberWithOptions(
                                                  signed: true, decimal: true),
                                              inputBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                  S.h(90.0.h),
                                  InkWell(
                                    onTap: () {
                                      if (_phoneNumberController
                                          .text.isNotEmpty) {
                                        login.sendCodeToPhoneNumber(context);
                                      } else {
                                        formKey.currentState?.validate();
                                      }
                                    },
                                    child: Container(
                                      width: 202,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        color: const Color(0xff6f9fc4),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'next'.tr(),
                                          style: TextStyle(
                                            fontFamily: FontFamily.PromptMedium,
                                            fontSize: 21,
                                            color: AppColors.white,
                                            letterSpacing: 2.1,
                                            fontWeight: FontWeight.w500,
                                            height: 0.9523809523809523,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30.0, right: 35.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${"version".tr()} ${' ' + version.toString()}",
                                          style: TextStyle(
                                              fontFamily:
                                                  FontFamily.PromptRegular,
                                              fontSize: 16,
                                              color: AppColors.white
                                                  .withOpacity(0.8)),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                              ),
                            ],
                          ),
                        )),
                  ],
                )),
      ),
    );
  }
}
