import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aicp/themes/app_colors.dart';
import 'package:aicp/themes/app_images.dart';
import 'package:aicp/widgets/sizebox_widgets.dart';
import 'package:aicp/screens/index_screen.dart';
import 'package:aicp/widgets/push_page_transition.dart';

class ReferFriendThankScreen extends StatefulWidget {
  const ReferFriendThankScreen({Key? key}) : super(key: key);

  @override
  _ReferFriendThankScreenState createState() => _ReferFriendThankScreenState();
}

class _ReferFriendThankScreenState extends State<ReferFriendThankScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  ImagesThemes.bgMR,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () => PushPageTran.push(context, const IndexScreen()),
                  child: const SizedBox(
                    height: 65,
                    width: 95,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 250),
                  height: 650.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        30,
                      ),
                      topRight: Radius.circular(30),
                    ),
                    color: AppColors.indigoBgMrHistory,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 37.0, left: 53.0),
                            child: Row(
                              children: [
                                Text(
                                  'referFriend2'.tr(),
                                  style: const TextStyle(
                                    fontFamily: 'Prompt',
                                    fontSize: 22,
                                    color: Color(0xff032d54),
                                    letterSpacing: 2.2,
                                    fontWeight: FontWeight.w500,
                                    height: 0.8181818181818182,
                                  ),
                                  textHeightBehavior: const TextHeightBehavior(
                                      applyHeightToFirstAscent: false),
                                )
                              ],
                            ),
                          ),
                          S.h(8.0),
                          Text(
                            'done2'.tr(),
                            style: const TextStyle(
                              fontFamily: 'Prompt',
                              fontSize: 17,
                              color: Color(0xffff0000),
                              letterSpacing: 1.7000000000000002,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                              height: 1.3529411764705883,
                            ),
                            textHeightBehavior: const TextHeightBehavior(
                                applyHeightToFirstAscent: false),
                          ),
                          S.h(22.0),
                          Text(
                            'thankYou'.tr(),
                            style: const TextStyle(
                              fontFamily: 'Prompt',
                              fontSize: 35,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w600,
                              height: 0.6571428571428571,
                            ),
                            textHeightBehavior: const TextHeightBehavior(
                                applyHeightToFirstAscent: false),
                            textAlign: TextAlign.left,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, left: 53.0),
                            child: Row(
                              children: [
                                Text(
                                  'ThankForReferring'.tr(),
                                  style: const TextStyle(
                                    fontFamily: 'Prompt',
                                    fontSize: 16,
                                    color: Color(0x80000000),
                                    fontWeight: FontWeight.w300,
                                    height: 1.4375,
                                  ),
                                  textHeightBehavior: const TextHeightBehavior(
                                      applyHeightToFirstAscent: false),
                                  textAlign: TextAlign.left,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, left: 53.0),
                            child: Row(
                              children: [
                                Text(
                                  '${'YouWillBeRewarded'.tr()}\n${'getsTheLoan'.tr()} ',
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
                                )
                              ],
                            ),
                          ),
                          S.h(48.0),
                          SvgPicture.asset(
                            ImagesThemes.thankRefer,
                            height: 138,
                            width: 210,
                          ),
                          S.h(61.0),
                          InkWell(
                            onTap: () => PushPageTran.pushReplacement(
                                context, const IndexScreen()),
                            child: Container(
                                width: 181,
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: const Color(0xff6f9fc4),
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
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
