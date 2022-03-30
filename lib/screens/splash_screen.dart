import 'dart:async';
import 'dart:io';
import 'package:aicp/service/logout_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'index_screen.dart';
import 'package:aicp/themes/app_colors.dart';
import 'package:aicp/themes/app_images.dart';
import 'package:aicp/utils/first_page.dart';
import 'package:aicp/const/pref_data.dart';
import 'package:aicp/screens/login_phone_screen.dart';
import 'package:aicp/utils/share_pref.dart';
import 'package:aicp/const/end_point.dart';
import 'package:aicp/const/secure_data.dart';
import 'package:aicp/service/http_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  late bool loginStatus;
  late bool registerStatus = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();

    // checkStatusRegister();
    checkLogin();
  }

  Future checkLogin() async {
    try {
      loginStatus = await SharedPref.readValue('bool', Preferences.loginStatus);
      if (loginStatus == true) {
        Future.delayed(const Duration(milliseconds: 3000), () {
          AppFirstPage.makeFirst(context, const IndexScreen());
        });
      } else {
        Future.delayed(const Duration(milliseconds: 3000), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const LoginPhoneScreen()));
        });
      }
    } catch (e) {
      await SharedPref.setValue('bool', Preferences.loginStatus, false);

      Future.delayed(const Duration(milliseconds: 3000), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPhoneScreen()));
      });
    }
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        PackageInfo packageInfo;
        packageInfo = await PackageInfo.fromPlatform();
        String version = packageInfo.version;

        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);

        Map data = {
          "os": "android",
          "systemName_ios": "",
          "systemVersion_ios": "",
          "model_ios": "",
          "localizedModel_ios": "",
          "isPhysicalDevice": deviceData['isPhysicalDevice'],
          "sdkInt_android": deviceData['version.sdkInt'],
          "release_android": deviceData['version.release'],
          "brand_android": deviceData['brand'],
          "model_android": deviceData['model'],
          "device_android": deviceData['device'],
          "product_android": deviceData['product'],
          "androidId_android": deviceData['androidId'],
          "version_Mapp": version
        };
        // print(data);

        saveLogFirstTime(data);
      } else if (Platform.isIOS) {
        PackageInfo packageInfo;
        packageInfo = await PackageInfo.fromPlatform();
        String version = packageInfo.version;

        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        // print(deviceData);
        Map data = {
          "os": "ios",
          "systemName_ios": deviceData['systemName'],
          "systemVersion_ios": deviceData['systemVersion'],
          "model_ios": deviceData['model'],
          "localizedModel_ios": deviceData['localizedModel'],
          "isPhysicalDevice": deviceData['isPhysicalDevice'],
          "sdkInt_android": "",
          "release_android": "",
          "brand_android": "",
          "model_android": "",
          "device_android": "",
          "product_android": "",
          "androidId_android": "",
          "version_Mapp": version
        };

        saveLogFirstTime(data);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Future saveLogFirstTime(dataSend) async {
    try {
      final response =
          await HttpService.post(Endpoints.saveLogFirstTime, dataSend);

      int status = response["statusCode"];

      if (status == 200) {
        print('Save Success');
      } else {
        print('Save Log Error!');
      }
    } catch (e) {
      print('Save Log Error!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SvgPicture.asset(
          ImagesThemes.bgLoading,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        Scaffold(
          backgroundColor: AppColors.indigoPrimary.withOpacity(0.9),
          body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SvgPicture.asset(
                ImagesThemes.appLogo,
                height: 64.28,
                width: 197.6,
              ),
              const SizedBox(
                height: 32.5,
              ),
              Text(
                "ព្រោះយើងស្មោះត្រង់និងទទួលខុសត្រូវជានិច្ច",
                style: TextStyle(
                    fontSize: 16, color: AppColors.white.withOpacity(0.85)),
              ),
              const SizedBox(
                height: 128.5,
              ),
              const SizedBox(
                height: 79.22,
                width: 79.22,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4D7CA7)),
                  backgroundColor: Color(0xFF9AABBB),
                  strokeWidth: 10,
                ),
              )
            ]),
          ),
        ),
      ],
    ));
  }
}
