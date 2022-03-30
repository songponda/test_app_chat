import 'package:aicp/const/pref_data.dart';
import 'package:aicp/utils/share_pref.dart';
import 'package:aicp/widgets/alert.dart';
import 'package:flutter/material.dart';
import 'package:aicp/const/end_point.dart';
import 'package:aicp/service/http_service.dart';
import 'package:aicp/models/car_detail_model.dart';

class CarDetailProvider extends ChangeNotifier {
  CarDetailModel? carDetailModel;
  late String languageType;

  Future<CarDetailModel?> getCarDetail(BuildContext context, carId) async {
    try {
      var lang =
          await SharedPref.readValue('string', Preferences.languageStatus);

      if (lang == null || lang == 'en') {
        languageType = "en";
      } else {
        languageType = "kh";
      }

      Map data = {"languageType": languageType, "carId": carId};

      final response = await HttpService.post(Endpoints.getCarByCarId, data);
      // print(response);

      int status = response["statusCode"];
      var res = response["data"][0];
      var msg = response["data"][0]["message"];

      if (status == 200 && res != null) {
        carDetailModel = CarDetailModel.fromJson(res);
        notifyListeners();
        return carDetailModel;
      } else if (status == 404 && msg == "Get data failed") {
        Alert.popupAlertErrorContactAdmin(context);

        /// ไม่เจอข้อมูลรถ
        return null;
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
