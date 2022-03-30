import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/src/intl/date_format.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import '../provider/profile_provider.dart';
import 'package:aicp/const/end_point.dart';
import 'package:aicp/const/secure_data.dart';
import 'package:aicp/screens/index_screen.dart';
import 'package:aicp/service/http_service.dart';
import 'package:aicp/themes/app_images.dart';
import 'package:aicp/widgets/push_page_transition.dart';
import 'package:aicp/component/appBar.dart';
import 'package:aicp/themes/app_colors.dart';
import 'package:aicp/widgets/sizebox_widgets.dart';
import 'package:aicp/const/pref_data.dart';
import 'package:aicp/service/logout_service.dart';
import 'package:aicp/utils/share_pref.dart';
import 'package:aicp/models/profile_model.dart';
import 'package:aicp/widgets/alert.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController FirstnameTextController = TextEditingController();
  TextEditingController LastnameTextController = TextEditingController();
  TextEditingController AddressTextController = TextEditingController();

  List<String> Years = [];

  String birthDay = "";
  String formattedDate = "";

  String province = "";
  List dataProvince = [];

  String branch_en = "";
  List branch_en_data = [];
  //Edit branch

  DateTime now = DateTime.now();

  late Future<ProfileModel?> _value;

  ProfileProvider? profileProvider;
  ProfileModel? profile;

  @override
  void initState() {
    super.initState();

    getDropdown();
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    DateTime now = DateTime.now();
    DateTime test = DateTime(now.year, now.month + 1, 0);
    final fiftyDaysFromNow = now.add(const Duration(days: 50));

    for (var i = 0; i <= 122; i++) {
      Years.add((i + 1900).toString());
    }
  }

  Future<dynamic> getDropdown() async {
    // Loader.show(context);

    final response = await HttpService.get(Endpoints.getDropdownDistrict);

    int statusCode = response["statusCode"];

    print(response);

    if (statusCode == 200) {
      // Loader.hide(context);
      print('ดึงสำเร็จ');
      setState(() {
        for (var i = 0; i < response["district"].length; i++) {
          dataProvince.add(response["district"][i]["name_cambodia"]);
          branch_en_data.add(response["district"][i]["branch_aicp"]);
          //Edit branch
        }
        print(dataProvince);
        print(branch_en_data);
      });
    } else {
      // Loader.hide(context);
    }

    return true;
  }

  Future updateRegister() async {
    try {
      const storage = FlutterSecureStorage();
      String? accessTokenStorage =
          await storage.read(key: SecureData.accessToken);
      String? userIdStorage = await storage.read(key: SecureData.userId);

      Map data = {
        "userId": userIdStorage,
        "accessToken": accessTokenStorage,
        "firstname": FirstnameTextController.text,
        "lastname": LastnameTextController.text,
        "adNumAddress": AddressTextController.text,
        "adTumbol": "",
        "adAmp": "",
        "adProvince": province,
        "branch_en": branch_en,
        "birthDay": formattedDate.toString()
      };

      print(data);

      final response = await HttpService.post(Endpoints.updateRegister, data);
      int status = response["statusCode"];

      print(response);

      if (status == 200) {
        Map data2 = {
          "message":
              "\n🏆  แจ้งเตือน Mapp AICP ลูกค้าสมัครเข้าใช้งาน\n👭 ️ชื่อลูกค้า : ${FirstnameTextController.text}\n👭 นามสกุลลูกค้า : ${LastnameTextController.text} \n📱 เบอร์โทรศัพท์ : ${response["data"][0]["phone_firebase"]}\n💳⏰ เวลา : ${now.toString()}\n"
        };

        final response2 =
            await HttpService.post(Endpoints.sendNotificationTelegram, data2);

        profile = await Provider.of<ProfileProvider>(context, listen: false)
            .getProfileUser(context);

        await SharedPref.setValue('bool', Preferences.registerStatus, true);

        _buildPopupSuccess();

      } else if (status == 401) {
        print("Unauthorized -> Logout!");
        LogoutService.logout(context);
        // return null;
      } else {
        Alert.popupAlertErrorContactAdmin(context);
        print("Error!");
      }
    } catch (e) {
      Alert.popupAlertErrorContactAdmin(context);
      print("Error! From Server");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF345776).withOpacity(0.6),
                  const Color(0xFFF0F3F5).withOpacity(0.1),
                ],
                begin: Alignment.bottomRight,
                end: Alignment(1.2, -1.25),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    headerAppBar(context),
                    Positioned(
                      top: 60,
                      left: 10,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 80,
                          child: const Align(
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
                S.h(50.0),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      formInput(context, "Firstname", FirstnameTextController),
                      S.h(20.0),
                      formInput(context, "Lastname", LastnameTextController),
                      S.h(20.0),
                      // InkWell(
                      //   onTap: () {
                      //     _buildBottomSheetPutParam(date);
                      //   },
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       color: Color(0xFFEFEFEF).withOpacity(0.8),
                      //       borderRadius: BorderRadius.circular(30.0),
                      //       border:
                      //           Border.all(color: Colors.grey.withOpacity(0.5)),
                      //     ),
                      //     width: MediaQuery.of(context).size.width * 0.9,
                      //     height: 45,
                      //     child: Padding(
                      //       padding: EdgeInsets.only(left: 15, right: 15),
                      //       child: Align(
                      //         alignment: AlignmentDirectional.centerStart,
                      //         child: Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           children: const [
                      //             Text(
                      //               "Date of Birth",
                      //               style: TextStyle(
                      //                 color: Color(0xFF9AABBB),
                      //               ),
                      //             ),
                      //             Icon(Icons.date_range,
                      //                 color: AppColors.indigoTran),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      InkWell(
                        onTap: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(1700, 3, 5),
                              maxTime: DateTime(2020, 6, 7), onChanged: (date) {
                            print('change $date');
                            setState(() {
                              birthDay = date.toString();
                            });
                            //
                            DateTime datePick = date;
                            formattedDate =
                                DateFormat('yyyy-MM-dd').format(datePick);

                            print(birthDay);
                          }, onConfirm: (date) {
                            print('confirm $date');
                            setState(() {
                              birthDay = date.toString();
                            });

                            print(birthDay);

                            DateTime datePick = date;
                            formattedDate =
                                DateFormat('yyyy-MM-dd').format(datePick);

                            print(formattedDate);
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        // onTap: () {
                        // _buildBottomSheetPutParam(date);
                        // },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFEFEFEF).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(30.0),
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.5)),
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 45,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  formattedDate == ""
                                      ? Text(
                                          "dateOfBirth".tr(),
                                          style: TextStyle(
                                            color: Color(0xFF9AABBB),
                                          ),
                                        )
                                      : Text(
                                          formattedDate.toString(),
                                          style: TextStyle(
                                            color: Color(0xFF9AABBB),
                                          ),
                                        ),
                                  const Icon(Icons.date_range,
                                      color: AppColors.indigoTran)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      S.h(20.0),
                      formInput(
                          context, "Address Number", AddressTextController),
                      S.h(2.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          S.w(MediaQuery.of(context).size.width * 0.05),
                          InkWell(
                            onTap: () {
                              // showPicker()
                              _buildBottomSheetPutParam("CityPV");

                              // print("itemsStart : 0");
                              setState(() {
                                province = dataProvince[0];
                                branch_en = branch_en_data[0];
                                //Edit branch
                              });
                              print(province);
                              print(branch_en);
                            },
                            child: Container(
                              height: 45,
                              width: MediaQuery.of(context).size.width * 0.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.5)),
                                  color: Color(0xFFF7F7F7)),
                              child: Padding(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      province == ""
                                          ? Text(
                                              "province".tr(),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Prompt',
                                                color: AppColors.indigoTran,
                                              ),
                                            )
                                          : Text(
                                              province,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Prompt',
                                                color: AppColors.indigoTran,
                                              ),
                                            ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        size: 28,
                                        color: AppColors.indigoTran,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      S.h(2.0),
                      // Row(
                      // S.h(2.0),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     S.w(MediaQuery.of(context).size.width * 0.05),
                      //     Container(
                      //       decoration: BoxDecoration(
                      //         color: Color(0xFFEFEFEF).withOpacity(0.8),
                      //         borderRadius: BorderRadius.circular(30.0),
                      //         border: Border.all(
                      //             color: Colors.grey.withOpacity(0.5)),
                      //       ),
                      //       width: MediaQuery.of(context).size.width * 0.35,
                      //       height: 45,
                      //       child: Padding(
                      //         padding:
                      //             const EdgeInsets.only(left: 15, right: 15),
                      //         child: Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           children: const [
                      //             Text(
                      //               "Subdistrict",
                      //               style: TextStyle(
                      //                 color: Color(0xFF9AABBB),
                      //               ),
                      //             ),
                      //             Icon(Icons.arrow_drop_down,
                      //                 color: AppColors.indigoTran),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      S.h(20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          S.w(MediaQuery.of(context).size.width * 0.05),
                          InkWell(
                            onTap: () {
                              updateRegister();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: AppColors.indigoPrimary),
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: 45,
                              child: const Center(
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      fontFamily: 'Prompt',
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      S.h(30.0),
                      Container(
                        color: AppColors.black.withOpacity(0.3),
                        height: 0.7,
                        width: 313,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 340,
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
                    ],
                  ),
                ),
                S.h(50.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildPopupSuccess() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)), //this right here
              child: SizedBox(
                width: 358,
                height: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    S.h(50.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'successful_register'.tr(),
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

  Widget formInput(context, subject, TextController) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFEFEFEF).withOpacity(0.8),
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 45,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: TextFormField(
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: subject.toString(),
              hintStyle: TextStyle(
                color: Color(0xFF9AABBB),
              )),
          controller: TextController,
          onChanged: (textController) {
            switch (subject) {
              case "Firstname":
                setState(() {
                  FirstnameTextController = TextController;
                });
                print(FirstnameTextController);
                break;
              case "Lastname":
                setState(() {
                  LastnameTextController = TextController;
                });
                break;
              case "Address":
                setState(() {
                  AddressTextController = TextController;
                });
                print(AddressTextController);
                break;
            }
          },
        ),
      ),
    );
  }

  // Future<dynamic> _buildBottomSheetPutParam(type) {
  //   return showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: false,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(
  //           top: Radius.circular(18.0),
  //         ),
  //       ),
  //       builder: (context) {
  //         return Stack(
  //           children: [
  //             Positioned(
  //                 top: 150,
  //                 left: MediaQuery.of(context).size.width * 0.1,
  //                 right: MediaQuery.of(context).size.width * 0.1,
  //                 child: Container(
  //                   height: 54,
  //                   width: MediaQuery.of(context).size.width * 0.9,
  //                   decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(30.0),
  //                       color: Color(0x99E8E8E8)),
  //                 )),
  //             SizedBox(
  //               height: MediaQuery.of(context).size.height * 0.40,
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 8.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Container(
  //                           width: 42,
  //                           height: 3,
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(2.0),
  //                             color: const Color(0xff9aabbb),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Padding(
  //                       padding: const EdgeInsets.only(
  //                           bottom: 10.0, left: 2.0, right: 2.0),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           InkWell(
  //                             onTap: () => Navigator.pop(context),
  //                             child: Container(
  //                               width: 80,
  //                               height: 30,
  //                               child: const Center(
  //                                 child: Text(
  //                                   'Cancel',
  //                                   style: TextStyle(
  //                                     fontFamily: 'Prompt',
  //                                     fontSize: 14,
  //                                     color: Color(0xFF022D54),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           InkWell(
  //                             onTap: () {
  //                               print("Done!!");
  //                             },
  //                             child: Container(
  //                               width: 80,
  //                               height: 30,
  //                               child: const Center(
  //                                 child: Text(
  //                                   'Done',
  //                                   style: TextStyle(
  //                                     fontFamily: 'Prompt',
  //                                     fontSize: 14,
  //                                     color: Color(0xFF022D54),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       )),
  //                   Container(
  //                     height: 1.0,
  //                     decoration: BoxDecoration(
  //                       color: Colors.black.withOpacity(0.1),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.grey.withOpacity(0.3),
  //                           spreadRadius: 1.25,
  //                           blurRadius: 5,
  //                           offset: Offset(0, 3), // changes position of shadow
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   selectType(type),
  //                 ],
  //               ),
  //             )
  //           ],
  //         );
  //       });
  // }

  // Widget selectType(type) {
  //   if (type == "date_birth") {
  //     return scrollInput(type);
  //   } else {
  //     return scrollInput(type);
  //   }
  // }
  //
  // Widget scrollInput(type) {
  //   return Expanded(
  //     child: Container(
  //         alignment: Alignment.topCenter,
  //         padding: EdgeInsets.only(top: 0),
  //         child: Row(
  //           children: [
  //             Expanded(
  //                 child: ListWheelScrollView(
  //               onSelectedItemChanged: (itemsChange) {
  //                 print("itemsChange : $itemsChange");
  //               },
  //               squeeze: 0.8,
  //               // ช่องว่างระหว่างลิส
  //               diameterRatio: 3.5,
  //               perspective: 0.01,
  //               itemExtent: 42,
  //               physics: FixedExtentScrollPhysics(),
  //               children: List.generate(type.length, (index) {
  //                 // print(index);
  //                 return SizedBox(
  //                   width: 300,
  //                   child: Text(
  //                     type[index],
  //                     style: const TextStyle(
  //                       fontFamily: 'Prompt',
  //                       fontSize: 24,
  //                       color: Color(0xFF022D54),
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 );
  //               }),
  //             )),
  //             Expanded(
  //                 child: ListWheelScrollView(
  //               onSelectedItemChanged: (itemsChange) {
  //                 print("itemsChange : $itemsChange");
  //               },
  //               squeeze: 0.8,
  //               // ช่องว่างระหว่างลิส
  //               diameterRatio: 3.5,
  //               perspective: 0.01,
  //               itemExtent: 42,
  //               physics: FixedExtentScrollPhysics(),
  //               children: List.generate(type.length, (index) {
  //                 // print(index);
  //                 return SizedBox(
  //                   width: 300,
  //                   child: Text(
  //                     type[index],
  //                     style: const TextStyle(
  //                       fontFamily: 'Prompt',
  //                       fontSize: 24,
  //                       color: Color(0xFF022D54),
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 );
  //               }),
  //             )),
  //             Expanded(
  //                 child: ListWheelScrollView(
  //               onSelectedItemChanged: (itemsChange) {
  //                 itemsChange = itemsChange + 1900;
  //                 print("Years : $itemsChange");
  //               },
  //               squeeze: 0.8,
  //               // ช่องว่างระหว่างลิส
  //               diameterRatio: 3.5,
  //               perspective: 0.01,
  //               itemExtent: 42,
  //               physics: FixedExtentScrollPhysics(),
  //               children: List.generate(Years.length, (index) {
  //                 // print(index);
  //                 return SizedBox(
  //                   width: 300,
  //                   child: Text(
  //                     Years[index],
  //                     style: const TextStyle(
  //                       fontFamily: 'Prompt',
  //                       fontSize: 24,
  //                       color: Color(0xFF022D54),
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 );
  //               }),
  //             )),
  //           ],
  //         )),
  //   );
  // }

  Future<dynamic> _buildBottomSheetPutParam(type) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(18.0),
          ),
        ),
        builder: (context) {
          return Stack(
            children: [
              Positioned(
                  top: MediaQuery.of(context).size.height * 0.166,
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  child: Container(
                    // height: MediaQuery.of(context).size.height * 0.07,
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: const Color(0x99E8E8E8)),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 1.0),
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
                    Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10.0, left: 2.0, right: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: SizedBox(
                                width: 80,
                                height: 30,
                                child: Center(
                                  child: Text(
                                    'cancel'.tr(),
                                    style: const TextStyle(
                                      fontFamily: 'Prompt',
                                      fontSize: 14,
                                      color: Color(0xFF022D54),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SizedBox(
                                width: 80,
                                height: 30,
                                child: Center(
                                  child: Text(
                                    'done'.tr(),
                                    style: const TextStyle(
                                      fontFamily: 'Prompt',
                                      fontSize: 14,
                                      color: Color(0xFF022D54),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                    Container(
                      height: 1.0,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1.25,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                    scrollInput(dataProvince)
                  ],
                ),
              )
            ],
          );
        });
  }

  Widget scrollInput(type) {
    return Expanded(
      child: Container(
          alignment: Alignment.topCenter,
          // margin: const EdgeInsets.only(top: 20),
          // padding: EdgeInsets.only(top: 20),
          child: ListWheelScrollView(
            onSelectedItemChanged: (itemsChange) {
              print("itemsChange : $itemsChange");
              setState(() {
                province = dataProvince[itemsChange];
                branch_en = branch_en_data[itemsChange];
                //Edit branch
              });
              print(province);
              print(branch_en);

              // setItemsChange(itemsChange, selectDropdown);
            },
            squeeze: 0.8,
            // ช่องว่างระหว่างลิส
            diameterRatio: 50,
            perspective: 0.01,
            itemExtent: 42.h,
            magnification: 1.6,
            useMagnifier: true,
            physics: FixedExtentScrollPhysics(),
            // controller: FixedExtentScrollController(
            //   initialItem: selectTempIndex,
            // ),
            children: List.generate(type.length, (index) {
              return SizedBox(
                width: 400.w,
                child: Text(
                  type[index],
                  style: const TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 16,
                    color: Color(0xFF022D54),
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }),
          )),
    );
  }
}
