import 'package:aicp/service/logout_service.dart';
import 'package:aicp/widgets/alert.dart';
import 'package:aicp/widgets/loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:aicp/themes/app_colors.dart';
import 'package:aicp/themes/app_images.dart';
import 'package:aicp/widgets/sizebox_widgets.dart';
import 'package:aicp/const/end_point.dart';
import 'package:aicp/const/secure_data.dart';
import 'package:aicp/screens/refer_friend_thank_screen.dart';
import 'package:aicp/service/http_service.dart';
import 'package:aicp/widgets/push_page_transition.dart';

class ReferFriendScreen extends StatefulWidget {
  const ReferFriendScreen({Key? key}) : super(key: key);

  @override
  _ReferFriendScreenState createState() => _ReferFriendScreenState();
}

class _ReferFriendScreenState extends State<ReferFriendScreen> {
  String rewardPerRefer = '100';
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController phoneNumTextController = TextEditingController();
  List<String> date = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
  List<String> Years = [];
  List<String> PhoneNum = ["+66", "+855"];
  List CityPV = ["city1", "city2", "city3", "city4"];
  List<String> TypeCollateral = ["Motocycle", "Moto 3 Wheels"];

  List<String> countries = ["India", "Usa", "Australia"];
  String selectedValue = "";

  String province = "";
  String branch = "";
  String typeData = "";
  String MRid = "";

  List dataProvince = [];
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    getMRStatus();
    getDropdown();

    DateTime now = DateTime.now();
    DateTime test = DateTime(now.year, now.month + 1, 0);
    final fiftyDaysFromNow = now.add(const Duration(days: 50));

    for (var i = 0; i <= 122; i++) {
      Years.add((i + 1900).toString());
    }
  }

  void getMRStatus() async {
    // Loader.show(context);

    try {
      const storage = FlutterSecureStorage();
      String? accessTokenStorage =
          await storage.read(key: SecureData.accessToken);
      String? userIdStorage = await storage.read(key: SecureData.userId);

      Map data = {"userId": userIdStorage, "accessToken": accessTokenStorage};

      final response = await HttpService.post(Endpoints.getMR, data);

      int status = response["statusCode"];
      var res = response["data"][0];

      print(response);

      if (status == 200 && res != null && res['ID_MR'] != null) {
        // Loader.hide(context);
        setState(() {
          MRid = res['ID_MR'];
        });
        // print(MRid);
      } else if (status == 401) {
        print("Unauthorized -> Logout!");
        // Loader.hide(context);
        LogoutService.logout(context);
      } else if (status == 404) {
        print("ต้องสมัคร MR");
      } else {
        // Loader.hide(context);
        Alert.popupAlertErrorContactAdmin(context);
        print("Error อื่น ๆ ติดต่อ Admin , และ ส่งข้อมูล Error ");
      }
    } catch (e) {
      // Loader.hide(context);
      Alert.popupAlertErrorContactAdmin(context);
      print("Error! From Server");
    }
  }

  Future sendDataReferFriend() async {
    try {
      const storage = FlutterSecureStorage();
      String? accessTokenStorage =
          await storage.read(key: SecureData.accessToken);
      String? userIdStorage = await storage.read(key: SecureData.userId);

      Map data = {
        "userId": userIdStorage,
        "accessToken": accessTokenStorage,
        "upload_img_car": "",
        "type_car": typeData,
        "province": province,
        "fname": firstNameTextController.text,
        "lname": lastNameTextController.text,
        "phone": phoneNumTextController.text,
        "phone_firebase": "",
        "id_mr": MRid.toString()
      };

      print(data);

      final response = await HttpService.post(Endpoints.referFriend, data);
      int status = response["statusCode"];

      print(response);

      if (status == 200) {
        Map data2 = {
          "message":
              "\nแจ้งเตือน Mapp AICP เมนู Refer friend\n👭 ️ชื่อ : ${firstNameTextController.text}\n👭 นามสกุล : ${lastNameTextController.text} \n📱 เบอร์โทรศัพท์ : ${phoneNumTextController.text}\n💳⏰\nรหัส MR : ${MRid.toString()}\nเวลา : ${now.toString()}\n"
        };

        final response2 =
            await HttpService.post(Endpoints.sendNotificationTelegram, data2);

        PushPageTran.push(context, const ReferFriendThankScreen());
      } else if (status == 401) {
        LogoutService.logout(context);
        print("Unauthorized -> Logout!");
        // return null;
      } else {
        print("Error!");
        Alert.popupAlertErrorContactAdmin(context);
      }
    } catch (e) {
      print("Error! From Server");
      Alert.popupAlertErrorContactAdmin(context);
    }
  }

  Future<dynamic> getDropdown() async {
    final response = await HttpService.get(Endpoints.getDropdownDistrict);

    int statusCode = response["statusCode"];

    print(response);

    if (statusCode == 200) {
      print('ดึงสำเร็จ');
      setState(() {
        for (var i = 0; i < response["district"].length; i++) {
          dataProvince.add(response["district"][i]["name_cambodia"]);
        }
        print(dataProvince);
      });
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
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
                    height: 530.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8ECEF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          30,
                        ),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 19.0, left: 22.0, right: 22.0),
                      child: InputForm(),
                    ),
                  ),
                ),
                Positioned(
                  top: 90,
                  left: 25,
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
          ),
        ),
      ),
    );
  }

  Widget InputForm() {
    return Column(
      children: [
        AutoSizeText.rich(TextSpan(children: [
          const TextSpan(
              text: "Get cash up to ",
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Prompt',
                  color: Color(0xFF636363))),
          TextSpan(
              text: rewardPerRefer + " USD ",
              style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Prompt',
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
          const TextSpan(
              text:
                  "per 1 refer. No obligation. You can refer as many as you want. No limitation.",
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Prompt',
                  color: Color(0xFF636363))),
        ])),
        S.h(18.0),
        const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                "Refer a friend",
                style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 19,
                    color: AppColors.indigoPrimary),
              ),
            )),
        S.h(18.0),
        Container(
          height: 55,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
              color: Color(0xFFF7F7F7)),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextFormField(
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Firstname",
                  hintStyle: TextStyle(
                    color: AppColors.indigoTran,
                  )),
              controller: firstNameTextController,
              onChanged: (firstNameTextController) {
                print(firstNameTextController);
              },
            ),
          ),
        ),
        S.h(18.0),
        Container(
          height: 55,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
              color: Color(0xFFF7F7F7)),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextFormField(
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Lastname",
                  hintStyle: TextStyle(
                    color: AppColors.indigoTran,
                  )),
              controller: lastNameTextController,
              onChanged: (lastNameTextController) {
                print(lastNameTextController);
              },
            ),
          ),
        ),
        S.h(18.0),
        // Container(
        //     height: 55,
        //     width: MediaQuery.of(context).size.width,
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(30.0),
        //         border: Border.all(color: Colors.grey.withOpacity(0.5)),
        //         color: Color(0xFFF7F7F7)),
        //     child: Padding(
        //       padding: const EdgeInsets.only(left: 20, right: 20),
        //       child: Row(
        //         children: [
        //           InkWell(
        //             onTap: () {
        //               _buildBottomSheetPutParam("PhoneNum");
        //             },
        //             child: Container(
        //               decoration: BoxDecoration(
        //                 border: Border(
        //                     right: BorderSide(
        //                         width: 1.0,
        //                         color: Colors.grey.withOpacity(0.5))),
        //               ),
        //               child: Row(
        //                 children: const [
        //                   Text(
        //                     "+66",
        //                     style: TextStyle(
        //                         fontFamily: 'Prompt',
        //                         color: AppColors.indigoTran),
        //                   ),
        //                   Icon(
        //                     Icons.arrow_drop_down,
        //                     size: 28,
        //                     color: AppColors.indigoTran,
        //                   )
        //                 ],
        //               ),
        //             ),
        //           ),
        //           S.w(8.0),
        //           Container(
        //             width: MediaQuery.of(context).size.width * 0.55,
        //             child: TextFormField(
        //               decoration: const InputDecoration(
        //                   border: InputBorder.none,
        //                   hintText: "Mobile Number",
        //                   hintStyle: TextStyle(
        //                       fontFamily: 'Prompt', color: Color(0xFF9AABBB))),
        //               controller: phoneNumTextController,
        //               onChanged: (phoneNumTextController) {
        //                 print(phoneNumTextController);
        //               },
        //             ),
        //           ),
        //         ],
        //       ),
        //     )),
        Container(
          height: 55,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
              color: Color(0xFFF7F7F7)),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Mobile Number",
                  hintStyle: TextStyle(
                    color: AppColors.indigoTran,
                  )),
              controller: phoneNumTextController,
              onChanged: (phoneNumTextController) {
                print(phoneNumTextController);
              },
            ),
          ),
        ),
        S.h(18.0),
        // Container(
        //   height: 55,
        //   width: MediaQuery.of(context).size.width,
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(30.0),
        //       border: Border.all(color: Colors.grey.withOpacity(0.5)),
        //       color: Color(0xFFF7F7F7)),
        //   child: Padding(
        //     padding: EdgeInsets.only(left: 15, right: 15),
        //     child: Align(
        //       alignment: AlignmentDirectional.centerStart,
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: const [
        //           Text(
        //             "Date of Birth",
        //             style: TextStyle(
        //               fontSize: 16,
        //               fontFamily: 'Prompt',
        //               color: AppColors.indigoTran,
        //             ),
        //           ),
        //           Icon(Icons.date_range, color: AppColors.indigoTran),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        // S.h(18.0),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: InkWell(
            onTap: () {
              _buildBottomSheetType("Collateral");

              // print("itemsStart : 0");
              setState(() {
                typeData = TypeCollateral[0];
              });
              print(typeData);
            },
            child: Container(
              height: 55,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  color: Color(0xFFF7F7F7)),
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      typeData == ""
                          ? const Text(
                              "Type of Collateral",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Prompt',
                                color: AppColors.indigoTran,
                              ),
                            )
                          : Text(
                              typeData,
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
        ),
        S.h(18.0),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: InkWell(
            onTap: () {
              // showPicker();
              _buildBottomSheetPutParam("CityPV");

              // print("itemsStart : 0");
              setState(() {
                province = dataProvince[0];
              });
              print(province);
            },
            child: Container(
              height: 55,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  color: Color(0xFFF7F7F7)),
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        ),
        S.h(18.0),
        InkWell(
          onTap: () {
            sendDataReferFriend();
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
                color: const Color(0xFF6F9FC4)),
            child: const Center(
              child: Text(
                "Next",
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Prompt', fontSize: 16),
              ),
            ),
          ),
        )
      ],
    );
  }

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
                  top: MediaQuery.of(context).size.height * 0.167,
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  child: Container(
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

  Widget selectType(type) {
    if (type == "date_birth") {
      return birthScrollInput(type);
    } else if (type == "PhoneNum") {
      return scrollInput(PhoneNum);
    } else if (type == "CityPV") {
      return scrollInput(CityPV);
    } else if (type == "Collateral") {
      return scrollInput(TypeCollateral);
    } else {
      return scrollInput(type);
    }
  }

  Widget birthScrollInput(type) {
    return Expanded(
      child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 0),
          child: Row(
            children: [
              Expanded(
                  child: ListWheelScrollView(
                onSelectedItemChanged: (itemsChange) {
                  print("itemsChange : $itemsChange");
                },
                squeeze: 0.8,
                // ช่องว่างระหว่างลิส
                diameterRatio: 3.5,
                perspective: 0.01,
                itemExtent: 42,
                physics: FixedExtentScrollPhysics(),
                children: List.generate(type.length, (index) {
                  // print(index);
                  return SizedBox(
                    width: 300,
                    child: Text(
                      type[index],
                      style: const TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: 24,
                        color: Color(0xFF022D54),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
              )),
              Expanded(
                  child: ListWheelScrollView(
                onSelectedItemChanged: (itemsChange) {
                  print("itemsChange : $itemsChange");
                },
                squeeze: 0.8,
                // ช่องว่างระหว่างลิส
                diameterRatio: 3.5,
                perspective: 0.01,
                itemExtent: 42,
                physics: FixedExtentScrollPhysics(),
                children: List.generate(type.length, (index) {
                  // print(index);
                  return SizedBox(
                    width: 300,
                    child: Text(
                      type[index],
                      style: const TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: 20,
                        color: Color(0xFF022D54),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
              )),
              Expanded(
                  child: ListWheelScrollView(
                onSelectedItemChanged: (itemsChange) {
                  itemsChange = itemsChange + 1900;
                  print("Years : $itemsChange");
                },
                squeeze: 0.8,
                // ช่องว่างระหว่างลิส
                diameterRatio: 3.5,
                perspective: 0.01,
                itemExtent: 42,
                physics: FixedExtentScrollPhysics(),
                children: List.generate(Years.length, (index) {
                  // print(index);
                  return SizedBox(
                    width: 300,
                    child: Text(
                      Years[index],
                      style: const TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: 20,
                        color: Color(0xFF022D54),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
              )),
            ],
          )),
    );
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
              });
              print(province);

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

  Future<dynamic> _buildBottomSheetType(type) {
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
                  top: MediaQuery.of(context).size.height * 0.16,
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  child: Container(
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
                    scrollInputType(TypeCollateral)
                  ],
                ),
              )
            ],
          );
        });
  }

  Widget scrollInputType(type) {
    return Expanded(
      child: Container(
          alignment: Alignment.topCenter,
          // margin: const EdgeInsets.only(top: 20),
          // padding: EdgeInsets.only(top: 20),
          child: ListWheelScrollView(
            onSelectedItemChanged: (itemsChange) {
              print("itemsChange : $itemsChange");
              setState(() {
                typeData = TypeCollateral[itemsChange];
              });
              print(typeData);

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
