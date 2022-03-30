// import 'dart:io';
// import 'package:package_info/package_info.dart';
//
// class AppVersion {
//   static String getOS() {
//     String os = Platform.operatingSystem;
//
//     return os;
//   }
//
//   static checkUpdate() async {
//     var currentVersion = await getCurrentVersion();
//     // print('currentVersion : ${currentVersion}');
//     var lastVersion = await getLastVersion();
//     // print('lastVersion : ${lastVersion}');
//     bool needUpdate;
//
//     if (currentVersion != null && lastVersion != null) {
//       currentVersion != lastVersion ? needUpdate = true : needUpdate = false;
//     } else {
//       needUpdate = false;
//     }
//
//     return needUpdate;
//   }
//
//   static getCurrentVersion() async {
//     PackageInfo packageInfo;
//     packageInfo = await PackageInfo.fromPlatform();
//
//     String appName = packageInfo.appName;
//     String packageName = packageInfo.packageName;
//     String version = packageInfo.version;
//     String buildNumber = packageInfo.buildNumber;
//
//     return version;
//   }
//
//   static getLastVersion() async {
//     String os = getOS();
//     String lastVersion = "";
//
//     if (os == 'android') {
//       Map data = {"packageName": "com.ruampattanaleasing.rplc_app"};
//
//       // print("dataSend" + " = " "$data");
//       final response =
//           await HttpService.post(Endpoints.checkVersionAndroid, data);
//       // print(response);
//
//       lastVersion = response['result']['version'];
//     } else if (os == 'ios') {
//       String url = Endpoints.getAppIOS + Endpoints.AppIDIOS;
//
//       final response = await HttpService.get(url);
//
//       lastVersion = response['results'][0]['version'];
//     }
//
//     return lastVersion;
//   }
// }
