import 'dart:ui';
import 'dart:io';
import 'dart:convert';
import 'package:aicp/const/pref_data.dart';
import 'package:aicp/utils/share_pref.dart';
import 'package:aicp/widgets/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import '../const/end_point.dart';
import 'package:aicp/routes/routes.dart';
import 'package:aicp/component/appBar.dart';
import 'package:aicp/component/drawer.dart';
import 'package:aicp/const/font_family.dart';
import 'package:aicp/themes/app_colors.dart';
import 'package:aicp/themes/app_images.dart';
import 'package:aicp/themes/app_textstyle.dart';
import 'package:aicp/widgets/sizebox_widgets.dart';
import 'package:aicp/provider/profile_provider.dart';
import 'package:aicp/models/profile_model.dart';
import 'package:aicp/screens/profile_edit_screen.dart';
import 'package:aicp/const/secure_data.dart';
import 'package:aicp/service/http_service.dart';
import 'package:aicp/widgets/loader.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  late Future<ProfileModel?> _value;

  ProfileProvider? profileProvider;
  ProfileModel? profile;

  File? imageFile;

  late bool registerStatus;

  @override
  void initState() {
    super.initState();

    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    _value = loadData();
  }

  Future<ProfileModel?> loadData() async {
    if (profileProvider!.profileModel == null) {
      // print('loading first');
      profile = await Provider.of<ProfileProvider>(context, listen: false)
          .getProfileUser(context);
      // print('------');
      // print(profile!.firstname);

      return profile;
    } else {
      // print('have data');
      // print('------');
      // profileProvider!.profileModel;
      return profileProvider!.profileModel;
    }
  }

  Future<dynamic> _onRefresh() async {
    // debugPrint(' onRefresh...');
    await Future.delayed(const Duration(milliseconds: 1000));
    profile = await Provider.of<ProfileProvider>(context, listen: false)
        .getProfileUser(context);
    return true;
  }

  Future<ProfileModel?> upLoadToS3() async {
    Loader.show(context);

    String base64Image = base64Encode(imageFile!.readAsBytesSync());
    // print(base64Image);

    // String? fileName = imageFile!.path.split("/").last;
    // // print('fileName is -> : ${fileName.toString()}');

    Map map = {
      "name": "MappRafco",
      "folder": "MappRafco/ProfileImage",
      "image": base64Image
    };

    final response =
        await HttpService.apiPostS3upload(Endpoints.uploadS3Center, map);

    print(response);
    var jsonResponse = json.decode(response);

    if (jsonResponse["statusCode"].toString() == "200") {
      var imgUpload = jsonResponse["result"]["url"]["Location"].toString();

      const storage = FlutterSecureStorage();
      String? accessTokenStorage =
          await storage.read(key: SecureData.accessToken);
      String? userIdStorage = await storage.read(key: SecureData.userId);

      Map data = {
        "userId": userIdStorage,
        "accessToken": accessTokenStorage,
        "profileImage": imgUpload
      };

      final response = await HttpService.post(Endpoints.editImageProfile, data);
      // print(response);
      int status = response["statusCode"];
      String? msg = response["message"];
      if (status == 200) {
        Loader.hide(context);

        Navigator.pop(context);

        profile = await Provider.of<ProfileProvider>(context, listen: false)
            .getProfileUser(context);

        return profile;
      }
    } else {
      Loader.hide(context);

      Fluttertoast.showToast(
          msg: "upload fail!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.indigoPrimary,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  void _camera() async {
    final ImagePicker _picker = ImagePicker();

    final cameraImage = await _picker.pickImage(source: ImageSource.camera);
    imageFile = cameraImage != null ? File(cameraImage.path) : null;

    // print('รูปจากกล้อง : ${imageFile}');

    upLoadToS3();
  }

  void _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;

    // print('รูป : ${imageFile}');

    upLoadToS3();
  }

  Future getRegisterStatus() async {
    registerStatus =
        await SharedPref.readValue('bool', Preferences.registerStatus);
    print(registerStatus);

    if (registerStatus == true) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ProfileEditScreen()));
    } else {
      Alert.popupAlertWarningForRegister(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: SizedBox(
        width: 280,
        child: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10.0,
                sigmaY: 10.0,
              ),
              child: Drawers(context),
            ),
          ),
        ),
      ),
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
        child: Column(
          children: [
            headerAppBar(context),
            Expanded(
                child: RefreshIndicator(
              key: refreshKey,
              color: AppColors.indigoPrimary,
              onRefresh: _onRefresh,
              child: FutureBuilder(
                  future: _value,
                  builder: (BuildContext context,
                      AsyncSnapshot<ProfileModel?> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return SpinKitThreeBounce(
                          size: 20.h,
                          color: AppColors.indigoPrimary,
                        );
                      default:
                        if (snapshot.hasData) {
                          return Consumer<ProfileProvider>(
                              builder: (context, profile, child) => ListView(
                                    padding: const EdgeInsets.only(top: 0),
                                    children: [
                                      Column(
                                        children: [
                                          S.h(69.9),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 31.0, right: 26),
                                              child: Stack(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15.w),
                                                    child: InkWell(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pushNamed(Routes
                                                                  .notification);
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 45.0),
                                                          height: 37,
                                                          width: 120,
                                                          child:
                                                              SvgPicture.asset(
                                                            ImagesThemes
                                                                .notificationIcon,
                                                            height: 35,
                                                            width: 27,
                                                          ),
                                                        )),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        onTap: () =>
                                                            _buildBottomSheetChooseImage(),
                                                        child: Stack(
                                                          children: [
                                                            profile.profileModel!
                                                                        .profile_img!
                                                                        .toString() ==
                                                                    ''
                                                                ? ClipOval(
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      ImagesThemes
                                                                          .iconUser,
                                                                      height:
                                                                          80,
                                                                      width: 80,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  )
                                                                : ClipOval(
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      width: 80,
                                                                      height:
                                                                          80,
                                                                      imageUrl: profile
                                                                          .profileModel!
                                                                          .profile_img!
                                                                          .toString(),
                                                                      placeholder: (context,
                                                                              url) =>
                                                                          const Center(
                                                                              child: CircularProgressIndicator()),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          const Icon(
                                                                              Icons.error),
                                                                    ),
                                                                  ),
                                                            Positioned(
                                                              left: -6,
                                                              bottom: -9,
                                                              child: SvgPicture
                                                                  .asset(
                                                                ImagesThemes
                                                                    .cameraIcon,
                                                                height: 45,
                                                                width: 45,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      InkWell(
                                                          onTap: () {
                                                            _scaffoldKey
                                                                .currentState!
                                                                .openEndDrawer();
                                                          },
                                                          child: const SizedBox(
                                                            height: 80,
                                                            width: 80,
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Icon(
                                                                Icons.settings,
                                                                color: AppColors
                                                                    .indigoProfile,
                                                                size: 34,
                                                              ),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          _buildDivider(),
                                          S.h(30.3),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 31.0, right: 26),
                                              child: Stack(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        onTap: () =>
                                                            getRegisterStatus(),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'profile1'.tr(),
                                                              style: TextStyleTheme
                                                                  .textProfile(
                                                                      context),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            ),
                                                            S.w(23.0),
                                                            InkWell(
                                                              onTap: () =>
                                                                  getRegisterStatus(),
                                                              child: SizedBox(
                                                                height: 23,
                                                                width: 23,
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  ImagesThemes
                                                                      .editIcon,
                                                                  height: 23,
                                                                  width: 23,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          S.h(10.0),
                                          _buildDivider(),
                                          S.h(30.3),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 31.0, right: 26),
                                              child: Stack(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'name1'.tr(),
                                                        style: TextStyleTheme
                                                            .textProfile(
                                                                context),
                                                      ),
                                                      SizedBox(
                                                        width: 230.w,
                                                        child: Text(
                                                          profile.profileModel!
                                                              .fullname!
                                                              .toString(),
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.right,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyleTheme
                                                              .textProfile(
                                                                  context),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          S.h(10.0),
                                          _buildDivider(),
                                          S.h(30.3),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 31.0, right: 26),
                                              child: Stack(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'tel1.'.tr(),
                                                        style: TextStyleTheme
                                                            .textProfile(
                                                                context),
                                                      ),
                                                      SizedBox(
                                                        width: 240,
                                                        // color: Colors.grey,
                                                        child: Text(
                                                          profile.profileModel!
                                                              .phone!
                                                              .toString(),
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.right,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyleTheme
                                                              .textProfile(
                                                                  context),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          _buildDivider(),
                                          S.h(30.3),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 31.0, right: 26),
                                              child: Stack(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'address'.tr(),
                                                        style: TextStyleTheme
                                                            .textProfile(
                                                                context),
                                                      ),
                                                      SizedBox(
                                                        width: 215,
                                                        child: Text(
                                                          profile
                                                                  .profileModel!.adNumAddress
                                                                  .toString() +
                                                              ' ' +
                                                              profile
                                                                  .profileModel!
                                                                  .adAmp!
                                                                  .toString() +
                                                              ' ' +
                                                              profile
                                                                  .profileModel!
                                                                  .adProvince!
                                                                  .toString() +
                                                              ' ' +
                                                              profile
                                                                  .profileModel!
                                                                  .adZipcode!
                                                                  .toString(),
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.right,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyleTheme
                                                              .textProfile(
                                                                  context),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          S.h(10.0),
                                          _buildDivider(),
                                          S.h(35.3),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 31.0, right: 26),
                                              child: contractUs()),
                                          S.h(120.0),
                                        ],
                                      )
                                    ],
                                  ));
                        } else {
                          return Padding(
                            padding:
                                const EdgeInsets.only(right: 45.0, top: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                    onTap: () {
                                      _scaffoldKey.currentState!
                                          .openEndDrawer();
                                    },
                                    child: const SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.settings,
                                          color: AppColors.indigoProfile,
                                          size: 34,
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          );
                        }
                    }
                  }),
            )),
          ],
        ),
      ),
    );
  }

  Widget contractUs() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "JoinOur".tr(),
                style: TextStyle(
                  color: AppColors.red,
                  fontSize: 16,
                  fontFamily: FontFamily.PromptBold,
                ),
              ),
              S.h(31.3),
              InkWell(
                onTap: () => _launchURLFacebookAICP(),
                child: subContractUs("Facebook",
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Facebook_Logo_%282019%29.png/1200px-Facebook_Logo_%282019%29.png"),
              ),
              S.h(24.0),
              InkWell(
                onTap: () => _launchURLTelegramAICP(),
                child: subContractUs("Telegram",
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Telegram_logo.svg/1024px-Telegram_logo.svg.png"),
              ),
            ],
          ),
        ],
      );

  Widget subContractUs(String socialMedia, String url) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            socialMedia,
            style: TextStyle(
                fontSize: 15,
                fontFamily: FontFamily.PromptRegular,
                color: AppColors.indigoProfileText),
          ),
          S.w(26.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(url, fit: BoxFit.cover, width: 26, height: 26),
          )
        ],
      );

  Widget _buildDivider() {
    return Divider(
      color: AppColors.black.withOpacity(0.2),
    );
  }

  Future _buildBottomSheetChooseImage() {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(36.0),
          ),
        ),
        builder: (context) {
          return SizedBox(
            height: 245,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 42,
                        height: 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.0),
                          color: const Color(0xff9aabbb),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 30.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Change profile photo',
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: 12,
                        color: Color(0xff345776),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: _buildDivider(),
                ),
                InkWell(
                  onTap: () => _camera(),
                  child: ListTile(
                      leading: SizedBox(
                        width: 36,
                        height: 36,
                        child: Image.asset(
                          ImagesThemes.cameraPlus,
                          width: 36,
                          height: 36,
                        ),
                      ),
                      title: const Text(
                        'Take a Picture',
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 17,
                          color: Color(0xff345776),
                        ),
                        textAlign: TextAlign.left,
                      )),
                ),
                InkWell(
                  onTap: () => _pickImage(),
                  child: ListTile(
                      leading: SizedBox(
                        width: 36,
                        height: 36,
                        child: Image.asset(
                          ImagesThemes.galleryIcon,
                          width: 36,
                          height: 36,
                        ),
                      ),
                      title: const Text(
                        'Select from album',
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 17,
                          color: Color(0xff345776),
                        ),
                        textAlign: TextAlign.left,
                      )),
                ),
              ],
            ),
          );
        });
  }

  _launchURLFacebookAICP() async {
    const url = 'https://m.me/AICPMotor';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURLTelegramAICP() async {
    const url = 'https://t.me/aicpmotor';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
