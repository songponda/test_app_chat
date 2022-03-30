import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../const/secure_data.dart';
import '../widgets/loader.dart';
import 'package:aicp/themes/app_colors.dart';
import 'package:aicp/widgets/button_widgets.dart';
import 'package:aicp/widgets/sizebox_widgets.dart';
import 'package:aicp/const/end_point.dart';
import 'package:aicp/service/http_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var formatter = DateFormat('dd MMM yy');
  var timeformatter = DateFormat.jm();
  List<dynamic> dataList = [];
  List datanotification = [];
  var datastatus = [];
  int counternotify = 0;

  @override
  void initState() {
    super.initState();

    callFunctionNotification();
  }

  callFunctionNotification() async {
    await getNotification();

    await checkreadstatusall();

    await checkreadStatus();
    // Loader.hide(context);
  }

  Future<dynamic> getNotification() async {
    // Loader.show(context);
    const storage = FlutterSecureStorage();
    String? accessTokenStorage =
        await storage.read(key: SecureData.accessToken);
    String? userIdStorage = await storage.read(key: SecureData.userId);

    Map data = {"accessToken": accessTokenStorage, "userId": userIdStorage};

    final response = await HttpService.post(Endpoints.getNotification, data);

    int statusCode = response["statusCode"];

    if (statusCode == 200) {
      setState(() {
        datanotification = response['response'];

        // print('555 $datanotification');
      });
    } else if (statusCode == 404) {
      // print('บันทึกไม่ได้ Error Param');
    }
  }

  Future<dynamic> checkreadstatusall() async {
    const storage = FlutterSecureStorage();
    String? accessTokenStorage =
        await storage.read(key: SecureData.accessToken);
    String? userIdStorage = await storage.read(key: SecureData.userId);

    Map data = {"accessToken": accessTokenStorage, "userId": userIdStorage};

    final response =
        await HttpService.post(Endpoints.loadNotificationStatusAll, data);

    int statusCode = response["statusCode"];

    if (statusCode == 200) {
      // print(response['response']);

      setState(() {
        datastatus = response['response'];
      });

      // Loader.hide(context);
    } else if (statusCode == 404) {
      // print('บันทึกไม่ได้ Error Param');

      // Loader.hide(context);
    }
  }

  Future<dynamic> checkreadstatus(
      idnotification, title, detail, typenotification) async {
    const storage = FlutterSecureStorage();
    String? accessTokenStorage =
        await storage.read(key: SecureData.accessToken);
    String? userIdStorage = await storage.read(key: SecureData.userId);

    Map data = {
      "accessToken": accessTokenStorage,
      "userId": userIdStorage,
      "idnotification": idnotification.toString()
    };

    final response =
        await HttpService.post(Endpoints.loadNotificationStatus, data);

    int statusCode = response["statusCode"];

    print('READ ###');

    print(response);

    if (statusCode == 200) {
      // print(response['result']);

      // AppNav.push(context, NotificationPage());
      checkreadstatusall();

      /// open detail!
      // setState(() {
      //   datastatus = response['result'];
      //
      //   print('load $datastatus');
      // });
    } else if (statusCode == 404) {
      // print('บันทึกไม่ได้ Error Param');
      savereadstatus(idnotification, title, detail, typenotification);
    }
  }

  savereadstatus(idnotification, title, detail, typenotification) async {
    const storage = FlutterSecureStorage();
    String? accessTokenStorage =
        await storage.read(key: SecureData.accessToken);
    String? userIdStorage = await storage.read(key: SecureData.userId);

    Map data = {
      "accessToken": accessTokenStorage,
      "userId": userIdStorage,
      "idnotification": idnotification.toString(),
      "status": "read"
    };

    final response =
        await HttpService.post(Endpoints.insertNotificationStatus, data);

    print('READ STATUS');

    print(response);
    int statusCode = response["statusCode"];

    if (statusCode == 200) {
      // print(response['result']);

      /// open detail!
      // setState(() {
      //   datastatus = response['result'];
      //
      //   print('load $datastatus');
      // });
    } else if (statusCode == 404) {
      // print('บันทึกไม่ได้ Error Param');
    }
  }

  savedeletestatus(idnotification) async {
    const storage = FlutterSecureStorage();
    String? accessTokenStorage =
        await storage.read(key: SecureData.accessToken);
    String? userIdStorage = await storage.read(key: SecureData.userId);

    Map data = {
      "accessToken": accessTokenStorage,
      "userId": userIdStorage,
      "idnotification": idnotification.toString(),
      "status": "delete"
    };

    final response =
        await HttpService.post(Endpoints.updateNotificationStatus, data);

    int statusCode = response["statusCode"];

    if (statusCode == 200) {
      // print(response['result']);

      await getNotification();

      await checkreadstatusall();

      /// hide bottom sheet แล้วดึง noti_status ใหม่ detail!

    } else if (statusCode == 404) {
      // print('บันทึกไม่ได้ Error Param');
    }
  }

  deleteAll() async {
    await checkreadstatusall();
    for (var i = 0; i < datanotification.length; i++) {
      int statusHaveRead = 0;
      for (var j = 0; j < datastatus.length; j++) {
        if (datanotification[i]["running"].toString() ==
            datastatus[j]["idnotification"].toString()) {
          statusHaveRead = 1;
          break;
        }
      }
      if (statusHaveRead == 0) {
        savereadstatus(
            datanotification[i]["running"].toString(),
            datanotification[i]["title"].toString(),
            datanotification[i]["detail"].toString(),
            datanotification[i]["typenotification"].toString());
      }
    }
    await Future.delayed(const Duration(seconds: 3));
    //เรียก function ลบทั้งหมด ของเบอร์นั้น
    await savedeleteAllstatus();
  }

  getDeleteAll() async {
    await deleteAll();

    // await savedeleteAllstatus();
  }

  savedeleteAllstatus() async {
    Loader.show(context);

    const storage = FlutterSecureStorage();
    String? accessTokenStorage =
        await storage.read(key: SecureData.accessToken);
    String? userIdStorage = await storage.read(key: SecureData.userId);

    Map data = {"accessToken": accessTokenStorage, "userId": userIdStorage};

    final response =
        await HttpService.post(Endpoints.updateAllNotificationStatus, data);

    int statusCode = response["statusCode"];
    if (statusCode == 200) {
      // print(response['result']);
      //
      print('200 OK ลบแล้วทั้งหมด!');

      await getNotification();

      await checkreadstatusall();
    } else if (statusCode == 404) {
      // print('บันทึกไม่ได้ Error Param');
    }

    Loader.hide(context);
  }

  delete(running, title, detail, typenotification) async {
    await checkreadstatusall();

    int statusHaveRead = 0;
    for (var j = 0; j < datastatus.length; j++) {
      if (running == datastatus[j]["idnotification"].toString()) {
        statusHaveRead = 1;
        break;
      }
    }
    if (statusHaveRead == 0) {
      savereadstatus(running, title, detail, typenotification);
    }
    // if (datanotification.length == i) {
    //   await new Future.delayed(const Duration(seconds: 6));
    //
    //   await savedeleteAllstatus();
    // }

    // await new Future.delayed(const Duration(seconds: 3));
    //เรียก function ลบทั้งหมด ของเบอร์นั้น
    await savedeleteonestatus(running);
  }

  savedeleteonestatus(running) async {
    Loader.show(context);

    const storage = FlutterSecureStorage();

    String? accessTokenStorage =
        await storage.read(key: SecureData.accessToken);
    String? userIdStorage = await storage.read(key: SecureData.userId);

    Map data = {
      "accessToken": accessTokenStorage,
      "userId": userIdStorage,
      "idnotification": running
    };

    print('Runing is => ${running}');

    final response =
        await HttpService.post(Endpoints.updateDelNotificationStatus, data);

    int statusCode = response["statusCode"];

    print('*******');

    print(response);
    if (statusCode == 200) {
      // print(response['result']);

      await getNotification();

      await checkreadstatusall();
    } else if (statusCode == 404) {
      // print('บันทึกไม่ได้ Error Param');
    }

    Loader.hide(context);
  }

  checkreadStatus() {
    print('เช็คจำนวน notification');

    int count = 0;
    // print(datanotification.length);
    // print(datastatus.length);

    for (var i = 0; i < datanotification.length; i++) {
      // print(i);

      for (var j = 0; j < datastatus.length; j++) {
        // print(j);

        if (datanotification[i]["running"].toString() ==
            datastatus[j]["idnotification"].toString()) {
          count = count + 1;
          break;
        }
      }
    }
    setState(() {
      counternotify = datanotification.length - count;

      // print(counternotify);
      //
      //
      // print(datanotification.length);
      //
      // print(count);
    });

    FlutterAppBadger.updateBadgeCount(counternotify);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            color: AppColors.indigoPrimary,
            child: Stack(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(top: 70, left: 2),
                        child: Button.backPopPage(context)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            margin: const EdgeInsets.only(top: 135),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  30,
                ),
                topRight: Radius.circular(30),
              ),
              color: AppColors.bgNotification,
            ),
            child: Stack(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: 17,
                        color: Color(0xff345776),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                /// Start All Delete Button
                Positioned(
                  left: 35,
                  top: 60,
                  child: GestureDetector(
                      onTap: () {
                        print('Delete All!');
                        deleteAll();
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 30.91,
                            height: 30.91,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                              color: AppColors.black,
                            ),
                            child: const Icon(Icons.close,
                                color: Colors.white, size: 20),
                          ),
                          S.w(15.0),
                          const Text(
                            'Delete All Read',
                            style: TextStyle(
                              fontFamily: 'NoToSansDisplay_Regular',
                              fontSize: 12,
                              color: Color(0xe5000000),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 100,
                  ),
                  child: ListView(children: ListMyWidgets(context)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> ListMyWidgets(context) {
    List<Widget> list = [];
    // print('ทดสอบ ${datanotification}');

    for (var i = 0; i < datanotification.length.toInt(); i++) {
      DateTime dateTime = DateTime.parse(datanotification[i]['create_time']);
      // print("ggg" + checkdelete(datanotification[i]["running"].toString()));
      // print("ggg" + datanotification.length.toString());
      if (checkdelete(datanotification[i]["running"].toString()) == "true") {
        // print("not process");
      } else {
        Color colorTextTitle = Color(0xff000000);
        Color colorTextDetail = Color(0xff000000).withOpacity(0.7);
        setState(() {
          if (checkread(datanotification[i]["running"].toString()) == "true") {
            colorTextTitle = Color(0xff000000).withOpacity(0.4);
            colorTextDetail = Color(0xff000000).withOpacity(0.4);
          } else {
            colorTextTitle = Color(0xff000000);
            colorTextDetail = Color(0xff000000).withOpacity(0.7);
          }
        });
        list.add(
          GestureDetector(
              onTap: () async {
                await checkreadstatus(
                    datanotification[i]["running"].toString(),
                    datanotification[i]["title"].toString(),
                    datanotification[i]["detail"].toString(),
                    datanotification[i]["typenotification"].toString());

                if (datanotification[i]["typenotification"].toString() ==
                    "bill") {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => ShowBillPdf(
                  //           datanotification[i]["img_notify"].toString())),
                  // );
                } else {
                  /// Call Bottom sheet to Show Detail.
                  showMaterialModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) => SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        height: 800.h,
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          // boxShadow: [mainContainer],
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.fromLTRB(50, 30, 30, 30),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                      Radius.circular(
                                        50.w,
                                      ),
                                    ),
                                    // boxShadow: [buttonShadow],
                                    color: Colors.white,
                                  ),
                                  child: Icon(Icons.close, size: 20.h),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                top: 20.h,
                                right: 20.w,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        timeformatter
                                                .format(dateTime)
                                                .toString() +
                                            '  .  ' +
                                            formatter
                                                .format(dateTime)
                                                .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'NoToSansDisplay_Regular',
                                          color: colorTextDetail,
                                          fontSize: 12.h,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30.h),
                                  Text(
                                    datanotification[i]["title"].toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 21.h,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25.h,
                                  ),
                                  ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(22.0)),
                                      child: Stack(
                                        children: <Widget>[
                                          Image.network(
                                            datanotification[i]["img_notify"]
                                                .toString(),
                                            fit: BoxFit.fill,
                                            width: 260.w,
                                            height: 210.h,
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  Text(
                                    datanotification[i]["detail"].toString(),
                                    style: TextStyle(
                                        fontFamily: 'NoToSansDisplay_Regular',
                                        color: Colors.black,
                                        fontSize: 14.h,
                                        letterSpacing: 1),
                                  ),
                                  SizedBox(
                                    height: 40.h,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                /// End Bottom sheet to Show Detail.
              },
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 340.w,
                            height: 130.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: AppColors.white.withOpacity(0.7),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x29ba6b00),
                                  offset: Offset(0, 3),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 260,
                                        child: Text(
                                          datanotification[i]["title"]
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'NoToSansDisplay_Bold',
                                            // color: colorTextTitle,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          print('Del!!!');

                                          delete(
                                              datanotification[i]["running"]
                                                  .toString(),
                                              datanotification[i]["title"]
                                                  .toString(),
                                              datanotification[i]["detail"]
                                                  .toString(),
                                              datanotification[i]
                                                      ["typenotification"]
                                                  .toString());
                                        },
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                50,
                                              ),
                                            ),
                                            // boxShadow: [buttonShadow],
                                            color: AppColors.white,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: AppColors.black,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  S.h(7.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 290,
                                        child: Text(
                                          datanotification[i]["detail"]
                                              .toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily:
                                                'NoToSansDisplay_Regular',
                                            // color: colorTextDetail,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  S.h(5.0),
                                  Row(
                                    children: [
                                      Text(
                                        timeformatter
                                                .format(dateTime)
                                                .toString() +
                                            '  .  ' +
                                            formatter
                                                .format(dateTime)
                                                .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'NoToSansDisplay_Regular',
                                          // color: colorTextDetail,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )),
        );
      }
    }
    return list;
  }

  checkread(idnotification) {
    var result = "false";
    for (var i = 0; i < datastatus.length; i++) {
      if (datastatus[i]["idnotification"].toString() == idnotification) {
        setState(() {
          result = "true";
        });
        break;
      }
    }
    return result;
  }

  checkdelete(idnotification) {
    var result = "false";
    for (var i = 0; i < datastatus.length; i++) {
      if (datastatus[i]["idnotification"].toString() == idnotification) {
        if (datastatus[i]["status"].toString() == "delete") {
          setState(() {
            result = "true";
          });
          break;
        }
      }
    }
    // print("testttttt" + datastatus.toString());
    return result;
  }
}
