import 'dart:ui';
import 'package:intl/src/intl/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aicp/component/appBar.dart';
import 'package:aicp/models/profile_model.dart';
import 'package:aicp/provider/profile_provider.dart';
import 'package:aicp/themes/app_colors.dart';
import 'package:aicp/widgets/sizebox_widgets.dart';
import 'package:aicp/const/end_point.dart';
import 'package:aicp/const/secure_data.dart';
import 'package:aicp/service/http_service.dart';
import 'package:aicp/service/logout_service.dart';
import 'package:aicp/widgets/alert.dart';
import 'package:aicp/widgets/loader.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController addressNumTextController = TextEditingController();
  List<String> Years = [];

  late Future<ProfileModel?> _value;
  ProfileProvider? profileProvider;
  ProfileModel? profile;

  String avatar = "";
  String birthDay = "";
  String dateConvert = "";
  String formattedDate = "";

  String province = "";
  List dataProvince = [];

  String branch_en = "";
  List branch_en_data = [];

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    DateTime test = DateTime(now.year, now.month + 1, 0);
    final fiftyDaysFromNow = now.add(const Duration(days: 50));

    for (var i = 0; i <= 122; i++) {
      Years.add((i + 1900).toString());
    }

    getDropdown();
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    _value = loadData();

    setDataFirst();
  }

  void setDataFirst() {
    setState(() {
      firstNameTextController.text = profileProvider!.profileModel!.firstname!;
      lastNameTextController.text = profileProvider!.profileModel!.lastname!;
      addressNumTextController.text =
          profileProvider!.profileModel!.adNumAddress!;
      avatar = profileProvider!.profileModel!.profile_img!;
      branch_en = profileProvider!.profileModel!.branch_en!;
      birthDay = profileProvider!.profileModel!.birthDay!;
      province = profileProvider!.profileModel!.adProvince!;
      // print(birthDay);

      if (birthDay != null) {
        DateTime dt = DateTime.parse(birthDay.toString());

        formattedDate = DateFormat("dd-MM-yyyy").format(dt);
      } else {
        formattedDate = "";
      }

      // print(formattedDate);
    });
  }

  Future<ProfileModel?> loadData() async {
    return profileProvider!.profileModel;
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

  Future<dynamic> editDataCustomer() async {
    Loader.show(context);

    const storage = FlutterSecureStorage();
    String? accessTokenStorage =
        await storage.read(key: SecureData.accessToken);
    String? userIdStorage = await storage.read(key: SecureData.userId);

    Map data = {
      "userId": userIdStorage,
      "accessToken": accessTokenStorage,
      "firstname": firstNameTextController.text,
      "lastname": lastNameTextController.text,
      "adNumAddress": addressNumTextController.text,
      "adTumbol": "",
      "adAmp": "",
      "adProvince": province,
      "branch_en": branch_en,
      "birthDay": birthDay.toString()
    };

    print(data);

    final response = await HttpService.post(Endpoints.editProfile, data);
    print(response);
    int status = response["statusCode"];
    var msg = response["message"];

    if (status == 200) {
      print('Success!');
      profile = await Provider.of<ProfileProvider>(context, listen: false)
          .getProfileUser(context);

      Loader.hide(context);

      Alert.popupAlertSuccessEditProfile("dataSuccessfully".tr(), context);
    } else if (status == 401) {
      Loader.hide(context);
      LogoutService.logout(context);
      print("Unauthorized -> Logout!");
      // return null;
    } else if (status == 404 && msg == "Update Failed") {
      print("Update Failed");
      Loader.hide(context);
      Alert.popupAlertErrorContactAdmin(context);
      // return null;
    } else {
      print("Error อื่น ๆ ติดต่อ Admin , และ ส่งข้อมูล Error ");
      Loader.hide(context);
      Alert.popupAlertErrorContactAdmin(context);

      return null;
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
          child: SingleChildScrollView(
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
                S.h(50.0),
                FutureBuilder(
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
                                builder: (context, profile, child) => Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFEFEFEF)
                                                .withOpacity(0.8),
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.5)),
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: 45,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Firstname",
                                                  hintStyle: TextStyle(
                                                    color: Color(0xFF9AABBB),
                                                  )),
                                              controller:
                                                  firstNameTextController,
                                            ),
                                            // child: Text(profile.profileModel!.firstname!.toString()),
                                          ),
                                        ),
                                        S.h(20.0),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFEFEFEF)
                                                .withOpacity(0.8),
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.5)),
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: 45,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Lastname",
                                                  hintStyle: TextStyle(
                                                    color: Color(0xFF9AABBB),
                                                  )),
                                              controller:
                                                  lastNameTextController,
                                            ),
                                          ),
                                        ),
                                        S.h(20.0),
                                        InkWell(
                                          onTap: () {
                                            DatePicker.showDatePicker(context,
                                                showTitleActions: true,
                                                minTime: DateTime(1700, 3, 5),
                                                maxTime: DateTime(2020, 6, 7),
                                                onChanged: (date) {
                                              print('change $date');
                                              setState(() {
                                                birthDay = date.toString();
                                              });

                                              DateTime datePick = date;
                                              formattedDate =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(datePick);

                                              print(birthDay);
                                            }, onConfirm: (date) {
                                              print('confirm $date');
                                              setState(() {
                                                birthDay = date.toString();
                                              });

                                              print(birthDay);

                                              DateTime datePick = date;
                                              formattedDate =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(datePick);

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
                                              color: Color(0xFFEFEFEF)
                                                  .withOpacity(0.8),
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.5)),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            height: 45,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15, right: 15),
                                              child: Align(
                                                alignment: AlignmentDirectional
                                                    .centerStart,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    formattedDate == ""
                                                        ? Text(
                                                            "dateOfBirth".tr(),
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF9AABBB),
                                                            ),
                                                          )
                                                        : Text(
                                                            formattedDate
                                                                .toString(),
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF9AABBB),
                                                            ),
                                                          ),
                                                    const Icon(Icons.date_range,
                                                        color: AppColors
                                                            .indigoTran)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        S.h(20.0),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFEFEFEF)
                                                .withOpacity(0.8),
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.5)),
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: 45,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Address Number",
                                                  hintStyle: TextStyle(
                                                    color: Color(0xFF9AABBB),
                                                  )),
                                              controller:
                                                  addressNumTextController,
                                            ),
                                          ),
                                        ),
                                        S.h(2.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            S.w(MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05),
                                            InkWell(
                                              onTap: () {
                                                // print("hi");
                                                _buildBottomSheetPutParam(
                                                    "CityPV");

                                                setState(() {
                                                  province = dataProvince[0];
                                                  branch_en = branch_en_data[0];
                                                  //Edit branch
                                                });
                                                print(province);
                                                print(branch_en);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFEFEFEF)
                                                      .withOpacity(0.8),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                  border: Border.all(
                                                      color: Colors.grey
                                                          .withOpacity(0.5)),
                                                ),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.35,
                                                height: 45,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15, right: 15),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      province == ""
                                                          ? Text(
                                                              "province".tr(),
                                                              style:
                                                                  const TextStyle(
                                                                color: Color(
                                                                    0xFF9AABBB),
                                                              ),
                                                            )
                                                          : Text(
                                                              province
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                color: Color(
                                                                    0xFF9AABBB),
                                                              ),
                                                            ),
                                                      const Icon(
                                                          Icons.arrow_drop_down,
                                                          color: AppColors
                                                              .indigoTran),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        S.h(20.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            S.w(MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05),
                                            InkWell(
                                              onTap: () {
                                                editDataCustomer();
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                    color: AppColors
                                                        .indigoPrimary),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.35,
                                                height: 45,
                                                child: const Center(
                                                  child: Text(
                                                    "Update Profile",
                                                    style: TextStyle(
                                                        fontFamily: 'Prompt',
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ));
                          } else {
                            return Container();
                          }
                      }
                    }),
                const Divider(
                  height: 80,
                  thickness: 0.25,
                  indent: 50,
                  endIndent: 50,
                  color: Color(0xFF707070),
                ),
                S.h(10.0),
                SizedBox(
                  width: 250,
                  height: 250,
                  child: Image.asset(
                    'assets/images/footer_login.png',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
