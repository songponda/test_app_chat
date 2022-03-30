import 'dart:ui';
import 'package:aicp/service/logout_service.dart';
import 'package:aicp/widgets/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/profile_model.dart';
import '../provider/profile_provider.dart';
import 'package:aicp/const/font_family.dart';
import 'package:aicp/themes/app_colors.dart';
import 'package:aicp/themes/app_images.dart';
import 'package:aicp/widgets/sizebox_widgets.dart';
import 'package:aicp/screens/mr_refer_friend_screen.dart';
import 'package:aicp/const/end_point.dart';
import 'package:aicp/const/secure_data.dart';
import 'package:aicp/service/http_service.dart';
import 'package:aicp/widgets/loader.dart';

class MRRewardScreen extends StatefulWidget {
  const MRRewardScreen({Key? key}) : super(key: key);

  @override
  _MRRewardScreenState createState() => _MRRewardScreenState();
}

class _MRRewardScreenState extends State<MRRewardScreen> {
  late Future<ProfileModel?> _value;

  ProfileProvider? profileProvider;
  ProfileModel? profile;

  late List dataList = [];

  var formatter = DateFormat('dd MMM yy');
  var resultData;

  String MRid = "";

  @override
  void initState() {
    super.initState();

    getMRStatus();

    getMRReward().then((result) {
      setState(() {
        resultData = result;
      });
    });

    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    _value = loadData();
  }

  Future<ProfileModel?> loadData() async {
    if (profileProvider!.profileModel == null) {
      profile = await Provider.of<ProfileProvider>(context, listen: false)
          .getProfileUser(context);
      return profile;
    } else {
      return profileProvider!.profileModel;
    }
  }

  void getMRStatus() async {
    try {
      const storage = FlutterSecureStorage();
      String? accessTokenStorage =
          await storage.read(key: SecureData.accessToken);
      String? userIdStorage = await storage.read(key: SecureData.userId);

      Map data = {"userId": userIdStorage, "accessToken": accessTokenStorage};

      final response = await HttpService.post(Endpoints.getMR, data);

      int status = response["statusCode"];
      var res = response["data"][0];

      if (status == 200 && res != null && res['ID_MR'] != null) {
        setState(() {
          MRid = res['ID_MR'];
        });
      } else if (status == 401) {
        print("Unauthorized -> Logout!");

        LogoutService.logout(context);
      } else if (status == 404) {
        print("ต้องสมัคร MR");
      } else {
        Alert.popupAlertErrorContactAdmin(context);
        print("Error อื่น ๆ ติดต่อ Admin , และ ส่งข้อมูล Error ");
      }
    } catch (e) {
      Alert.popupAlertErrorContactAdmin(context);
      print("Error! From Server");
    }
  }

  Future<dynamic> getMRReward() async {
    try {
      const storage = FlutterSecureStorage();
      String? accessTokenStorage =
          await storage.read(key: SecureData.accessToken);
      String? userIdStorage = await storage.read(key: SecureData.userId);

      Map data = {"accessToken": accessTokenStorage, "userId": userIdStorage};

      final response = await HttpService.post(Endpoints.getMRReward, data);
      int status = response["statusCode"];
      var msg = response["message"];
      // print(response['data']);

      if (status == 200) {
        setState(() {
          dataList = response['data'];
        });
        // print(dataList);
      } else if (status == 404 && msg == "No MR Reward") {
        setState(() {
          dataList == null;
        });
        print("ไม่มีข้อมูล Reward!");
      } else {
        print('ดึงข้อมูล Error!');
      }
    } catch (e) {
      print(e);

      print("Error! From Server");
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (resultData != true) {
      return Loader.loadSpin();
    }
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
            Positioned(
              bottom: 0,
              child: Container(
                height: 470.h,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      30,
                    ),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.transparent,
                ),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 40),
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
                        children: [
                          Column(
                            children: [
                              _buildMRNumber(),
                              _buildHeaderReward(),
                              S.h(21.0),
                              _buildDataReward(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildButtonHead(context),
                    _buildAvatar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder(
            future: _value,
            builder:
                (BuildContext context, AsyncSnapshot<ProfileModel?> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return ClipOval(
                    child: Container(
                      width: 90,
                      height: 90,
                      color: AppColors.indigoPrimary,
                    ),
                  );
                default:
                  if (snapshot.hasData) {
                    return Consumer<ProfileProvider>(
                      builder: (context, profile, child) =>
                          profile.profileModel!.profile_img!.toString() == ''
                              ? ClipOval(
                                  child: Container(
                                    color: AppColors.white,
                                    child: ClipOval(
                                      child: SvgPicture.asset(
                                        ImagesThemes.iconUser,
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                              : ClipOval(
                                  child: CachedNetworkImage(
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    imageUrl: profile.profileModel!.profile_img!
                                        .toString(),
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                    );
                  } else {
                    return ClipOval(
                      child: Container(
                        width: 90,
                        height: 90,
                        color: AppColors.indigoPrimary,
                      ),
                    );
                  }
              }
            })
      ],
    );
  }

  Widget _buildButtonHead(context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 48,
              width: 174,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  bottomLeft: Radius.circular(24.0),
                ),
                color: Color(0xff597691),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 11.0),
                  child: Text(
                    'history'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.w500,
                      height: 1.3125,
                    ),
                    textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReferFriendScreen(),
                    ));
              },
              child: Container(
                width: 186,
                height: 63,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(32.0),
                    bottomRight: Radius.circular(32.0),
                  ),
                  color: Color(0xffff0000),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x40000000),
                      offset: Offset(4, 3),
                      blurRadius: 9,
                    ),
                  ],
                ),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 61.0),
                  child: Row(
                    children: [
                      Text(
                        'referFriend'.tr(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w500,
                          height: 1.3125,
                        ),
                        textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false),
                        textAlign: TextAlign.center,
                      ),
                      S.w(5.0),
                      const Icon(
                        Icons.add,
                        color: AppColors.white,
                        size: 26.0,
                      ),
                    ],
                  ),
                )),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildMRNumber() {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, top: 70.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'your_MR_ID'.tr(),
            style: TextStyle(
              fontFamily: FontFamily.PromptMedium,
              fontSize: 16,
              color: const Color(0xe5161615),
              fontWeight: FontWeight.w300,
              height: 1.3125,
            ),
            textAlign: TextAlign.left,
          ),
          S.w(10.0),
          Text(
            MRid.toString(),
            style: TextStyle(
              fontFamily: FontFamily.PromptMedium,
              fontSize: 16,
              color: const Color(0xff345776),
              letterSpacing: 1.6,
              fontWeight: FontWeight.w500,
              height: 1.3125,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderReward() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Text(
              'Date',
              style: TextStyle(
                fontFamily: FontFamily.PromptRegular,
                fontSize: 14,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ), //Container
          ),
          Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(
                'reference_list'.tr(),
                style: TextStyle(
                  fontFamily: FontFamily.PromptRegular,
                  fontSize: 14,
                  color: const Color(0xff000000),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ) //Container
              ),
          Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(
                'rewarded'.tr(),
                style: TextStyle(
                  fontFamily: FontFamily.PromptRegular,
                  fontSize: 14,
                  color: const Color(0xff000000),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ) //Container
              ),
        ],
      ),
    );
  }

  Widget _buildDataReward() {
    return dataList != null
        ? SizedBox(
            height: 250.h,
            child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text(
                            formatter
                                .format(DateTime.parse(
                                    dataList[index]['create_time']))
                                .toString(),
                            style: TextStyle(
                              fontFamily: FontFamily.PromptRegular,
                              fontSize: 14,
                              color: const Color(0x993c3c43),
                            ),
                            textAlign: TextAlign.center,
                          ), //Container
                        ),
                        Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Text(
                              dataList[index]['branch'],
                              // 'Motorcycle',
                              style: TextStyle(
                                fontFamily: FontFamily.PromptRegular,
                                fontSize: 14,
                                color: const Color(0x993c3c43),
                              ),
                              textAlign: TextAlign.center,
                            ) //Container
                            ),
                        Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Text(
                              dataList[index]['price_sum'].toString() +
                                  ' ' +
                                  dataList[index]['Cur'],
                              // '130,000',
                              style: TextStyle(
                                fontFamily: FontFamily.PromptRegular,
                                fontSize: 14,
                                color: const Color(0x993c3c43),
                              ),
                              textAlign: TextAlign.center,
                            ) //Container
                            ),
                      ],
                    ),
                    S.h(11.0),
                    const Divider(),
                    S.h(11.0),
                  ],
                );
              },
            ),
          )
        : const Center(child: Text('No data'));
  }
}
