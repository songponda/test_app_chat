import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aicp/const/end_point.dart';
import 'package:aicp/const/secure_data.dart';
import 'package:aicp/service/http_service.dart';
import 'package:aicp/models/profile_model.dart';
import 'package:aicp/service/logout_service.dart';
import 'package:aicp/widgets/alert.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel? profileModel;

  // ProfileModel? get getProfileModel => profileModel;

  Future<ProfileModel?> getProfileUser(BuildContext context) async {
    // profileModel = null;
    try {
      const storage = FlutterSecureStorage();
      String? accessTokenStorage =
          await storage.read(key: SecureData.accessToken);
      String? userIdStorage = await storage.read(key: SecureData.userId);

      Map data = {"userId": userIdStorage, "accessToken": accessTokenStorage};

      final response = await HttpService.post(Endpoints.profile, data);

      int status = response["statusCode"];
      var res = response["data"][0];
      var msg = response["data"][0]["message"];

      if (status == 200 && res != null) {
        profileModel = ProfileModel.fromJson(res);
        notifyListeners();
        return profileModel;
      } else if (status == 401) {
        print("Unauthorized -> Logout!");
        LogoutService.logout(context);
        // return null;
      } else if (status == 404 && msg == "No data user") {
        /// ไม่เจอข้อมูล Profile User
        Alert.popupAlertErrorContactAdmin(context);
        print("No Data User -> Logout!");
        // return null;
      } else {
        Alert.popupAlertErrorContactAdmin(context);
        print("Error อื่น ๆ ติดต่อ Admin , และ ส่งข้อมูล Error ");
        return null;
      }
    } catch (e) {
      Alert.popupAlertErrorContactAdmin(context);
      print("Error อื่น ๆ ติดต่อ Admin , และ ส่งข้อมูล Error ");
      return null;
    }
    return null;
  }
}
