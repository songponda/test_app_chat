import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:aicp/widgets/button_widgets.dart';
import 'package:aicp/themes/app_colors.dart';
import 'package:aicp/widgets/background_widgets.dart';
import 'package:aicp/widgets/sizebox_widgets.dart';
import 'package:aicp/const/font_family.dart';
import 'package:aicp/utils/device_utils.dart';
import 'package:aicp/provider/login_provider.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String initialCountry = 'KH';
  PhoneNumber number = PhoneNumber(isoCode: 'KH');
  final TextEditingController _pinController = TextEditingController();

  final bool _cursorEnable = true;
  final bool _solidEnable = false;
  final ColorBuilder _solidColor =
      PinListenColorBuilder(Colors.grey, Colors.grey.withOpacity(0.4));

  late CountdownTimerController controller;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 120;

  bool showSendOTPAgain = false;
  bool showSendAgain = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      showSendAgain = false;
    });
    controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'KH');

    setState(() {
      this.number = number;
    });
  }

  void onEnd() {
    Provider.of<LoginProvider>(context, listen: false).setShowSendAgain(true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => DeviceUtils.focusScopeNode(context),
      child: Scaffold(
          body: Stack(
        children: [
          Background.imageBgSplash(context),
          Consumer<LoginProvider>(
            builder: (context, login, child) => Scaffold(
                backgroundColor: AppColors.indigoPrimary.withOpacity(0.85),
                body: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 85, left: 10),
                              child: Button.backPopPage(context))
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 180.h),
                        child: Column(children: [
                          Align(
                            alignment: Alignment.center,
                            child: Background.imageLogoAppSplash(context),
                          ),
                          S.h(44.0),
                          Text(
                            'enterOTP'.tr(),
                            style: TextStyle(
                              fontFamily: FontFamily.PromptSemiBold,
                              fontSize: 20,
                              color: const Color(0xffe6e6e6),
                              letterSpacing: 0.6,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          S.h(24.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'SendToMobile'.tr(),
                                style: TextStyle(
                                  fontFamily: FontFamily.PromptRegular,
                                  fontSize: 16,
                                  color: const Color(0xffe6e6e6),
                                  letterSpacing: 0.48,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                login.getPhoneHide,
                                style: TextStyle(
                                  fontFamily: FontFamily.PromptRegular,
                                  fontSize: 17,
                                  color: const Color(0xffffffff),
                                  letterSpacing: 0.9,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              )
                            ],
                          ),
                          S.h(10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'refCode'.tr(),
                                style: TextStyle(
                                  fontFamily: FontFamily.PromptRegular,
                                  fontSize: 16,
                                  color: const Color(0xffe6e6e6),
                                  letterSpacing: 0.48,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                '${login.loginOtp!.refCode}',
                                style: TextStyle(
                                  fontFamily: FontFamily.PromptRegular,
                                  fontSize: 17,
                                  color: const Color(0xffffffff),
                                  letterSpacing: 0.9,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: PinInputTextField(
                              // textCapitalization:
                              //     const TextStyle(color: AppColors.white),
                              keyboardType: TextInputType.number,
                              autoFocus: false,
                              pinLength: 6,
                              controller: _pinController,
                              decoration: BoxLooseDecoration(
                                strokeColorBuilder: PinListenColorBuilder(
                                    Colors.grey.withOpacity(0.8), Colors.white),
                                bgColorBuilder:
                                    _solidEnable ? _solidColor : null,
                                textStyle: const TextStyle(
                                    color: AppColors.white, fontSize: 20),
                              ),
                              textInputAction: TextInputAction.go,
                              enableInteractiveSelection: false,
                              cursor: Cursor(
                                width: 2,
                                color: AppColors.white,
                                radius: const Radius.circular(1),
                                enabled: _cursorEnable,
                              ),
                              enabled: true,
                              onChanged: (pin) {
                                if (pin.length == 6) {
                                  login.verifyOTPAndLoginWithPhone(
                                      context, pin);
                                  // debugPrint('onChanged execute. pin : $pin');
                                }
                              },
                            ),
                          ),
                          S.h(17.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'didGetCode'.tr(),
                                style: TextStyle(
                                  fontFamily: FontFamily.PromptRegular,
                                  fontSize: 14,
                                  color: const Color(0xffe6e6e6),
                                  letterSpacing: 0.48,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              login.getShowSendAgain == true
                                  ? InkWell(
                                      onTap: () => login
                                          .sendAgainCodeToPhoneNumber(context),
                                      child: Container(
                                        width: 114,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: const Color(0xff345776),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x29000000),
                                              offset: Offset(0, 2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'resendOTP'.tr(),
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.PromptRegular,
                                                fontSize: 10,
                                                color: const Color(0xffffffff),
                                                letterSpacing: 1.1,
                                                fontWeight: FontWeight.w700,
                                                height: 0.9090909090909091,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const Icon(
                                              Icons.refresh,
                                              color: AppColors.white,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : CountdownTimer(
                                      controller: controller,
                                      onEnd: onEnd,
                                      endTime: endTime,
                                      widgetBuilder: (_, endTime) {
                                        return Text(
                                          '${endTime!.sec} ${'second'.tr()}',
                                          style: TextStyle(
                                            fontFamily:
                                                FontFamily.PromptRegular,
                                            fontSize: 14,
                                            color: const Color(0xffe6e6e6),
                                            letterSpacing: 0.48,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.left,
                                        );
                                      }),
                            ],
                          ),
                          // S.h(150.0.h),
                          // Container(
                          //   width: 202,
                          //   height: 60,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(30.0),
                          //     color: const Color(0xff6f9fc4),
                          //   ),
                          //   child: Center(
                          //     child: Text(
                          //       'submit'.tr(),
                          //       style: TextStyle(
                          //         fontFamily: FontFamily.PromptMedium,
                          //         fontSize: 21,
                          //         color: AppColors.white,
                          //         letterSpacing: 2.1,
                          //         fontWeight: FontWeight.w500,
                          //         height: 0.9523809523809523,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ]),
                      ),
                    ],
                  ),
                )),
          )
        ],
      )),
    );
  }
}
