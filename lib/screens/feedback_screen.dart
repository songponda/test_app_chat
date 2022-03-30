import 'dart:io';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../provider/profile_provider.dart';
import 'package:aicp/themes/app_images.dart';
import 'package:aicp/widgets/sizebox_widgets.dart';
import 'package:aicp/const/end_point.dart';
import 'package:aicp/service/http_service.dart';
import 'package:aicp/models/profile_model.dart';
import 'package:aicp/service/get_os_service.dart';
import 'package:aicp/themes/app_colors.dart';
import 'package:aicp/widgets/alert.dart';
import 'package:aicp/widgets/loader.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  List<dynamic> show = [];
  List<IconData> iconRadio = [];
  File? imageFile;

  String urlImage = "";
  bool imgStatus = false;
  late String os = "";
  int starRating = 0;
  late Future<ProfileModel?> _value;

  ProfileProvider? profileProvider;
  ProfileModel? profile;
  late String optionSelect = "";

  TextEditingController suggestionsTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getOS();

    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    _value = loadData();
  }

  Future<ProfileModel?> loadData() async {
    profile = await Provider.of<ProfileProvider>(context, listen: false)
        .getProfileUser(context);
    return profile;
  }

  getOS() async {
    var _os = await GetOSService.getOS();

    setState(() {
      os = _os;
    });
  }

  sendDataFeedback() async {
    try {
      Map data = {
        "point": starRating.toString(),
        "message": suggestionsTextController.text,
        "type": optionSelect,
        "image": urlImage.toString(),
        "os": os,
        "fullname": profile!.fullname,
        "phone": profile!.phone,
        "phone_firebase": profile!.phone_firebase,
      };

      print(data);

      final response = await HttpService.post(Endpoints.feedback, data);
      int status = response["statusCode"];

      print(response);

      if (status == 200) {
        Map data2 = {
          "message":
              "แจ้งเตือน feedback \n🔔 แจ้งเตือนจาก App AICP\n⭕️ชื่อลูกค้า : ${profile!.fullname}\n📱เบอร์โทรศัพท์ : ${profile!.phone}\n⭕  คะแนน : ${starRating.toString()}/5\n⭕  หัวข้อ : ${optionSelect}\n⭕  ข้อเสนอแนะเพิ่มเติม : ${suggestionsTextController.text}\n",
          "image": urlImage.toString()
        };
        print(data2);

        final response2 = await HttpService.post(
            Endpoints.sendNotificationTelegramAndImage, data2);
        int status2 = response2["statusCode"];

        if (status2 == 200) {
          setState(() {
            starRating = 0;
            optionSelect == null;
            suggestionsTextController.text = '';
            urlImage = '';
            imgStatus = false;
          });

          Alert.popupAlertSaveSuccess("thank_for_feedback".tr(), context);
        } else {
          Alert.popupAlertErrorContactAdmin(context);
        }
      } else {
        Alert.popupAlertErrorContactAdmin(context);
        print("Error!");
      }
    } catch (e) {
      Alert.popupAlertErrorContactAdmin(context);
      print("Error! From Server");
    }
  }

  void upLoadToS3() async {
    Loader.show(context);

    String base64Image = base64Encode(imageFile!.readAsBytesSync());
    // print(base64Image);

    // String? fileName = imageFile!.path.split("/").last;
    // // print('fileName is -> : ${fileName.toString()}');

    Map map = {
      "name": "MappRafco",
      "folder": "MappRafco/feedback",
      "image": base64Image
    };

    final response =
        await HttpService.apiPostS3upload(Endpoints.uploadS3Center, map);

    // print(response);
    var jsonResponse = json.decode(response);

    if (jsonResponse["statusCode"].toString() == "200") {
      Loader.hide(context);
      setState(() {
        urlImage = jsonResponse["result"]["url"]["Location"].toString();
      });
      print(urlImage);
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

  void _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;

    // print('รูป : ${imageFile}');

    Navigator.pop(context);

    upLoadToS3();
  }

  delPicture() {
    setState(() {
      urlImage = '';
      imgStatus = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF032D54),
                Color(0xFF305679),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    SizedBox(
                      height: 140,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SvgPicture.asset(
                              ImagesThemes.appLogo,
                              height: 33.25,
                              width: 102.21,
                            ),
                          ],
                        ),
                      )),
                    ),
                    Positioned(
                      top: 60,
                      left: 10,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const SizedBox(
                          width: 80,
                          child: Align(
                            alignment: AlignmentDirectional.bottomStart,
                            child: Icon(
                              Icons.navigate_before,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "How would you rate our app ?",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Prompt',
                            fontSize: 22),
                      ),
                      S.h(16.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStar(1),
                            _buildStar(2),
                            _buildStar(3),
                            _buildStar(4),
                            _buildStar(5),
                          ],
                        ),
                      ),
                      S.h(15.0),
                      const Divider(
                        indent: 10,
                        endIndent: 10,
                        thickness: 1,
                        color: Color(0xFFDBDBDB),
                      ),
                      S.h(15.0),
                      const AutoSizeText(
                        "What was the biggest problem during your experience with our app ?",
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Prompt',
                          fontSize: 16,
                        ),
                      ),
                      S.h(20.0),
                      _buildOption("feedback_1".tr()),
                      _buildOption("feedback_2".tr()),
                      _buildOption("feedback_3".tr()),
                      _buildOption("feedback_4".tr()),
                      _buildOption("feedback_5".tr()),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.57,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8ECEF),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 22),
                    child: Column(
                      children: [
                        AutoSizeText(
                          "feedback_suggestion".tr(),
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Prompt',
                          ),
                        ),
                        S.h(10.0),
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.5)),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              maxLines: null,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "feedback_write".tr(),
                                  hintStyle: TextStyle(
                                    color: Color(0xFF636363).withOpacity(0.5),
                                  )),
                              controller: suggestionsTextController,
                              // onChanged: (suggestionsTextController) {
                              //   print(suggestionsTextController);
                              // },
                            ),
                          ),
                        ),
                        S.h(4.0),
                        imgStatus
                            ? InkWell(
                                onTap: () => delPicture(),
                                child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 50,
                                      right: 50,
                                    ),
                                    padding: const EdgeInsets.all(40),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                          6,
                                        ),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF000000)
                                              .withOpacity(0.05),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        )
                                      ],
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Change Image',
                                          style: TextStyle(
                                            fontFamily:
                                                'NotoSansDisplay-Medium',
                                            fontSize: 12,
                                            color: const Color(0x4d000000),
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        Stack(
                                          children: <Widget>[
                                            Transform.translate(
                                              offset:
                                                  const Offset(-298.84, 413.78),
                                              child: Stack(
                                                children: <Widget>[
                                                  Transform.translate(
                                                    offset: const Offset(
                                                        641.84, 303.22),
                                                    child: Container(
                                                      width: 18.0,
                                                      height: 18.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2.0),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 26,
                                              ),
                                              child: SizedBox(
                                                width: 25,
                                                height: 25,
                                                child: Icon(
                                                  Icons.cancel,
                                                  color:
                                                      const Color(0xffE81E25),
                                                  size: 18,
                                                  semanticLabel: 'Delete image',
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                              )
                            : InkWell(
                                onTap: () => _buildBottomSheetChooseImage(),
                                child: Container(
                                  height: 45,
                                  width: MediaQuery.of(context).size.width * 1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.5)),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        urlImage == null || urlImage == ''
                                            ? Text(
                                                "upload_screenshot".tr(),
                                                style: TextStyle(
                                                  color: const Color(0xFF636363)
                                                      .withOpacity(0.5),
                                                  fontFamily: 'Prompt',
                                                  fontSize: 14,
                                                ),
                                              )
                                            : Text(
                                                "screenShot_selected".tr(),
                                                style: TextStyle(
                                                  color: const Color(0xFF636363)
                                                      .withOpacity(0.5),
                                                  fontFamily: 'Prompt',
                                                  fontSize: 14,
                                                ),
                                              ),
                                        Icon(
                                          Icons.image,
                                          size: 30,
                                          color: const Color(0xFF636363)
                                              .withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        S.h(18.0),
                        InkWell(
                          onTap: () => sendDataFeedback(),
                          child: Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.5)),
                              color: const Color(0xFF6F9FC4),
                            ),
                            child: Center(
                              child: Text(
                                "submit".tr(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontFamily: 'Prompt'),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildOption(text) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 15,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            optionSelect = text;
          });
        },
        child: SizedBox(
          width: 300,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                optionSelect == text
                    ? FontAwesomeIcons.dotCircle
                    : FontAwesomeIcons.circle,
                size: 21,
                color: const Color(0xFFFFFFFF),
              ),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Prompt',
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildStar(number) {
    return GestureDetector(
      onTap: () {
        setState(() {
          starRating = number;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(
          left: 5,
          right: 5,
        ),
        child: starRating >= number
            ? const Icon(
                FontAwesomeIcons.solidStar,
                size: 32,
                color: Color(0xFFFFFFFF),
              )
            : const Icon(
                FontAwesomeIcons.star,
                size: 32,
                color: Color(0xFFFFFFFF),
              ),
      ),
    );
  }

  _buildBottomSheetChooseImage() {
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
                      'Choose photo feedback',
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: 12,
                        color: Color(0xff345776),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
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
}
