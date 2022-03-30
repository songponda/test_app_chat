import 'dart:ui';
import 'package:aicp/screens/mr_refer_friend_screen.dart';
import 'package:aicp/screens/refer_friend_thank_screen.dart';
import 'package:aicp/service/logout_service.dart';
import 'package:aicp/widgets/alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../service/http_service.dart';
import 'package:aicp/component/appBar.dart';
import 'package:aicp/themes/app_images.dart';
import 'package:aicp/widgets/sizebox_widgets.dart';
import 'package:aicp/widgets/push_page_transition.dart';
import 'package:aicp/const/end_point.dart';
import 'package:aicp/const/pref_data.dart';
import 'package:aicp/const/secure_data.dart';
import 'package:aicp/models/profile_model.dart';
import 'package:aicp/provider/profile_provider.dart';
import 'package:aicp/screens/index_screen.dart';
import 'package:aicp/screens/register_screen.dart';
import 'package:aicp/themes/app_colors.dart';
import 'package:aicp/utils/share_pref.dart';

class MRScreen extends StatefulWidget {
  const MRScreen({Key? key}) : super(key: key);

  @override
  _MRScreenState createState() => _MRScreenState();
}

class _MRScreenState extends State<MRScreen> {
  late bool registerStatus;

  late Future<ProfileModel?> _value;

  ProfileProvider? profileProvider;
  ProfileModel? profile;

  @override
  void initState() {
    super.initState();

    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    _value = loadData();
  }

  Future<ProfileModel?> loadData() async {
    profile = await Provider.of<ProfileProvider>(context, listen: false)
        .getProfileUser(context);
    // print('------');
    // print(profile!.firstname);

    return profile;
  }

  void registerMr() async {
    try {
      registerStatus =
          await SharedPref.readValue('bool', Preferences.registerStatus);

      if (registerStatus == true) {
        /// ไป API สมัคร MR โดยดึงข้อมูลจาก tb_user // เสร็จแล้วไปหน้า MR_reward

        const storage = FlutterSecureStorage();
        String? accessTokenStorage =
            await storage.read(key: SecureData.accessToken);
        String? userIdStorage = await storage.read(key: SecureData.userId);

        Map data = {
          "userId": userIdStorage,
          "accessToken": accessTokenStorage,
          "branch": profile!.branch_en,
          "fname": profile!.firstname,
          "lname": profile!.lastname,
          "career": ""
        };

        // print(data);

        final response = await HttpService.post(Endpoints.registerMR, data);

        // print(response);

        int status = response["statusCode"];
        var idMR = response["data"];

        if (status == 200 && idMR != null) {
          _buildPopShowMRNumber(idMR);
        } else if (status == 401) {
          print("Unauthorized -> Logout!");
          LogoutService.logout(context);
        } else if (status == 404) {
          print("สมััคร Error!");
          Alert.popupAlertErrorContactAdmin(context);
          // PushPageTran.push(context, const IndexScreen());
        } else {
          print("Error อื่น ๆ ติดต่อ Admin , และ ส่งข้อมูล Error ");
        }
      } else {
        /// ไปสมัครก่อน
        PushPageTran.push(context, const RegisterScreen());
      }
    } catch (e) {
      print("Error! From Server");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => const ReferFriendScreen()));
        //   },
        //   child: const Icon(Icons.navigation),
        //   backgroundColor: Colors.green,
        // ),
        body: Container(
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF345776).withOpacity(0.6),
            const Color(0xFFF0F3F5).withOpacity(0.1),
          ],
          begin: Alignment.bottomRight,
          end: const Alignment(1.2, -1.25),
        ),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 37.0, top: 140.0, right: 37),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'mr_represent'.tr(),
                        style: const TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 23,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                        textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false),
                        textAlign: TextAlign.left,
                      ),
                      S.h(11.0),
                      Text.rich(
                        TextSpan(
                          style: const TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 16,
                            color: Color(0xff000000),
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: 'joinUs'.tr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: 'mr2'.tr(),
                              style: const TextStyle(
                                color: Color(0xff0043ff),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '${'mrRegister1'.tr()}\n${'loanAICP'.tr()}\n\n${'GetCashUp'.tr()}\n${'noObligation'.tr()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false),
                        textAlign: TextAlign.left,
                      ),
                      const Divider(),
                      S.h(48.9),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      ImagesThemes.motorGrey,
                      width: 90.64,
                      height: 59,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'motorcycle'.tr(),
                          style: const TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 17,
                            color: Color(0xff000000),
                            letterSpacing: 0.8500000000000001,
                            fontWeight: FontWeight.w600,
                            height: 1.1176470588235294,
                          ),
                          textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          textAlign: TextAlign.left,
                        ),
                        S.h(5.0),
                        Text.rich(
                          TextSpan(
                            style: const TextStyle(
                              fontFamily: 'Prompt',
                              fontSize: 17,
                              color: Color(0xff000000),
                              letterSpacing: 0.8500000000000001,
                              height: 1.1176470588235294,
                            ),
                            children: [
                              TextSpan(
                                text: 'GetUp'.tr(),
                              ),
                              const TextSpan(
                                text: '30',
                                style: TextStyle(
                                  color: Color(0xffff0000),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const TextSpan(
                                text: ' USD',
                                style: TextStyle(
                                  color: Color(0xffff0000),
                                ),
                              ),
                              const TextSpan(
                                text: ' ',
                                style: TextStyle(
                                  color: Color(0xfffc030c),
                                ),
                              ),
                              TextSpan(text: '1refer'.tr()),
                            ],
                          ),
                          textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 260,
                      width: 350,
                      child: SvgPicture.asset(
                        ImagesThemes.motorRed,
                        fit: BoxFit.contain,
                        width: 400,
                        height: 500,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => popupAlertMrRegister(context),
                      child: Container(
                        width: 203,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(69.0),
                          color: const Color(0xffc70000),
                        ),
                        child: Center(
                          child: Text(
                            'applyMR'.tr(),
                            style: const TextStyle(
                              fontFamily: 'Prompt',
                              fontSize: 19,
                              color: Color(0xffffffff),
                              letterSpacing: 0.57,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                S.h(40.0)
              ],
            ),
          ),
          headerAppBar(context),
        ],
      ),
    ));
  }

  _buildPopShowMRNumber(String idMrNumber) {
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
                height: 550,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    S.h(22.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'mr_represent'.tr(),
                          style: const TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 19,
                            color: Color(0xff022d54),
                            fontWeight: FontWeight.w500,
                            height: 1.263157894736842,
                          ),
                          textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 38.0, top: 39),
                      child: Text(
                        'mr_number_is'.tr(),
                        style: const TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 17,
                          color: Color(0xff363636),
                          height: 1.411764705882353,
                        ),
                        textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 38.0, top: 18),
                        child: Text(
                          idMrNumber,
                          // 'MPN-AP-01',
                          style: const TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 34,
                            color: Color(0xff597691),
                            fontWeight: FontWeight.w600,
                            height: 0.6764705882352942,
                          ),
                          textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          textAlign: TextAlign.left,
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 38.0, top: 21),
                        child: Text(
                          'mr_earning'.tr(),
                          style: const TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 17,
                            color: Color(0x80000000),
                            fontWeight: FontWeight.w300,
                            height: 1.411764705882353,
                          ),
                          textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          textAlign: TextAlign.left,
                        )),
                    S.h(70.0),
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
                                  const Icon(
                                    Icons.check,
                                    color: AppColors.white,
                                    size: 27.0,
                                  ),
                                  S.w(5.0),
                                  Text(
                                    'mr_success'.tr(),
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

  popupAlertMrRegister(context) {
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
                height: 250.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    S.h(90.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${'alertMrRegister'.tr()}\n${'alertMrRegister2'.tr()}",
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
                          onTap: () => registerMr(),
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
}
