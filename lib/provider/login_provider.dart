import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aicp/const/end_point.dart';
import 'package:aicp/models/login_otp_model.dart';
import 'package:aicp/routes/routes.dart';
import 'package:aicp/service/http_service.dart';
import 'package:aicp/widgets/alert.dart';
import 'package:aicp/widgets/loader.dart';
import 'package:aicp/utils/device_utils.dart';
import 'package:aicp/const/secure_data.dart';
import 'package:aicp/screens/index_screen.dart';
import 'package:aicp/utils/first_page.dart';
import 'package:aicp/const/pref_data.dart';
import 'package:aicp/utils/share_pref.dart';

class LoginProvider extends ChangeNotifier {
  LoginOtp? loginOtp;

  String phone = '';
  String phoneNationCode = '';
  String phoneParam = '';
  String phoneHide = '';
  bool showSendAgain = false;

  String get getPhone => phone;
  String get getPhoneHide => phoneHide;
  String get getPhoneNationCode => phoneNationCode;
  bool get getShowSendAgain => showSendAgain;

  LoginOtp? get getLoginOtp => loginOtp;

  void setPhone(String value) {
    phone = value;
  }

  void setPhoneNationCode(String value) {
    phoneNationCode = value;
  }

  void setShowSendAgain(bool value) {
    showSendAgain = value;
    notifyListeners();
  }

  void sendCodeToPhoneNumber(BuildContext context) async {
    Loader.show(context);
    try {
      print(phoneNationCode);

      if (phoneNationCode == "+855123456789") {
        print('เบอร์ทดสอบ');

        Map data = {};

        final response =
            await HttpService.post(Endpoints.getTokenUserTest, data);

        int status = response["statusCode"];
        if (status == 200) {
          var roleRes = "user";
          var accessTokenRes = response["accessToken"];
          var refreshTokenRes = response["refreshToken"];
          var userIdRes = response["userId"];

          ///  set Data
          const storage = FlutterSecureStorage();

          /// write Data
          await storage.write(key: SecureData.roleId, value: roleRes);
          await storage.write(key: SecureData.userId, value: userIdRes);
          await storage.write(
              key: SecureData.accessToken, value: accessTokenRes);
          await SharedPref.setValue('bool', Preferences.loginStatus, true);
          Loader.hide(context);
          await storage
              .write(key: SecureData.refreshToken, value: refreshTokenRes)
              .then((value) =>
                  AppFirstPage.makeFirst(context, const IndexScreen()));
        }
      } else {
        phoneHide = phoneNationCode.substring(0, 3) +
            ' ' +
            "XXXXXX" +
            phoneNationCode.substring(8);

        Map data = {
          "from": "AICP",
          "phone": phoneNationCode,
          "typeSMS": "Qsms",
        };

        final response = await HttpService.post(Endpoints.requestOTP, data);

        int status = response["statusCode"];
        var result = response["result"];

        if (status == 200 && result == true) {
          loginOtp = LoginOtp.fromJson(response);
          notifyListeners();
          // print(loginOtp!.refCode);

          Loader.hide(context);
          Navigator.of(context).pushNamed(Routes.otp);
        } else if (status == 400) {
          Loader.hide(context);
          Alert.alert1button(context, 'invalid'.tr(), '', 'okay'.tr());
        } else if (status == 202) {
          Loader.hide(context);
          Alert.alert1button(context, 'please_1_min'.tr(), '', 'okay'.tr());
        } else if (status == 404) {
          Loader.hide(context);
          Alert.alert1button(context, 'sendOTPError'.tr(), '', 'okay'.tr());
        } else {
          Loader.hide(context);
          Alert.alert1button(context, 'serverError'.tr(), '', 'okay'.tr());
        }
      }
    } catch (e) {
      Loader.hide(context);
      Alert.alert1button(context, 'serverError'.tr(), '', 'okay'.tr());
    }
  }

  void sendAgainCodeToPhoneNumber(BuildContext context) async {
    Loader.show(context);
    try {
      phoneHide = phoneNationCode.substring(0, 3) +
          ' ' +
          "XXXXXX" +
          phoneNationCode.substring(8);

      Map data = {
        "from": "AICP",
        "phone": phoneNationCode,
        "typeSMS": "Qsms",
      };

      final response = await HttpService.post(Endpoints.requestOTP, data);

      int status = response["statusCode"];
      var result = response["result"];

      if (status == 200 && result == true) {
        loginOtp = LoginOtp.fromJson(response);
        showSendAgain = false;
        notifyListeners();
        // print(loginOtp!.refCode);

        Loader.hide(context);

        Navigator.of(context).pushReplacementNamed(Routes.otp);
      } else if (status == 400) {
        Loader.hide(context);
        Alert.alert1button(context, 'invalid'.tr(), '', 'okay'.tr());
      } else if (status == 202) {
        Loader.hide(context);
        Alert.alert1button(context, 'please_1_min'.tr(), '', 'okay'.tr());
      } else if (status == 404) {
        Loader.hide(context);
        Alert.alert1button(context, 'sendOTPError'.tr(), '', 'okay'.tr());
      } else {
        Loader.hide(context);
        Alert.alert1button(context, 'serverError'.tr(), '', 'okay'.tr());
      }
    } catch (e) {
      Loader.hide(context);
      Alert.alert1button(context, 'serverError'.tr(), '', 'okay'.tr());
    }
  }

  void verifyOTPAndLoginWithPhone(BuildContext context, String smsCode) async {
    await DeviceUtils.hideKeyboard(context);
    Loader.show(context);
    try {
      var checkPhone = phone.substring(0, 1);

      if (checkPhone == "0") {
        phoneParam = phone;
      } else {
        phoneParam = '0' + phone;
      }

      Map data = {
        "phone": phoneNationCode,
        "otpCode": smsCode,
        "refCode": getLoginOtp!.refCode,
        "fromBU": "AICP",
        "firstname": "",
        "lastname": ""
      };

      final response = await HttpService.post(Endpoints.verifyOTP, data);
      int status = response["statusCode"];
      var msg = response["message"];

      if (status == 200) {
        Map data = {"phone": phoneParam, "phoneFirebase": phoneNationCode};

        final response =
            await HttpService.post(Endpoints.signUpWithPhone, data);

        int status = response["statusCode"];
        var roleRes = "user";
        var accessTokenRes = response["accessToken"];
        var refreshTokenRes = response["refreshToken"];
        var userIdRes = response["userId"];

        if (status == 200) {
          ///  set Data
          const storage = FlutterSecureStorage();

          /// write Data
          await storage.write(key: SecureData.roleId, value: roleRes);
          await storage.write(key: SecureData.userId, value: userIdRes);
          await storage.write(
              key: SecureData.accessToken, value: accessTokenRes);
          await SharedPref.setValue('bool', Preferences.loginStatus, true);
          Loader.hide(context);
          await storage
              .write(key: SecureData.refreshToken, value: refreshTokenRes)
              .then((value) =>
                  AppFirstPage.makeFirst(context, const IndexScreen()));
        } else {
          Loader.hide(context);
          Alert.alert1button(
              context, 'login_failed'.tr(), '', 'okay'.tr().toString());
        }
      } else if (status == 404 && msg == "Send Data failed") {
        Loader.hide(context);
        Alert.alert1button(
            context, 'verify_failed'.tr(), '', 'okay'.tr().toString());
      } else if (status == 401 && msg == "Unauthorized") {
        Loader.hide(context);
        Alert.alert1button(
            context, 'wrong_otp'.tr(), '', 'okay'.tr().toString());
      } else if (status == 404 && msg == "otp timeout") {
        Loader.hide(context);
        Alert.alert1button(
            context, 'otp_timeout'.tr(), '', 'okay'.tr().toString());
      } else if (status == 500 && msg == "Internal Server") {
        Loader.hide(context);
        Alert.alert1button(
            context, 'serverError'.tr(), '', 'okay'.tr().toString());
      } else {
        Loader.hide(context);
        Alert.alert1button(
            context, 'registerError'.tr(), '', 'okay'.tr().toString());
      }
    } catch (e) {
      Loader.hide(context);
      Alert.alert1button(
          context, 'serverError'.tr(), '', 'okay'.tr().toString());
    }
  }
}
