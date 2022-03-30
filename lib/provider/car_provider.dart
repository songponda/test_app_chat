import 'package:aicp/const/pref_data.dart';
import 'package:aicp/utils/share_pref.dart';
import 'package:flutter/material.dart';
import 'package:aicp/const/end_point.dart';
import 'package:aicp/models/car_model.dart';
import 'package:aicp/service/http_service.dart';
import 'package:aicp/models/car_list.dart';

class CarsProvider extends ChangeNotifier {
  CarsList? carsList;
  List<CarsModel?>? carsModel;

  late String languageType;

  Future<CarsList?> getCarAll(BuildContext context) async {
    try {
      var lang =
          await SharedPref.readValue('string', Preferences.languageStatus);

      if (lang == null || lang == 'en') {
        languageType = "en";
      } else {
        languageType = "kh";
      }

      Map data = {"languageType": languageType};

      final response = await HttpService.post(Endpoints.getCarAll, data);

      int status = response["statusCode"];
      var respData = response["data"];
      // print(respData);

      if (status == 200) {
        carsList = CarsList.fromJson(respData);

        carsModel = carsList!.data;

        notifyListeners();

        return carsList;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
