import 'package:flutter/material.dart';
import 'package:aicp/const/end_point.dart';
import 'package:aicp/service/http_service.dart';
import 'package:aicp/models/car_offer_list.dart';
import 'package:aicp/models/car_offer_model.dart';

class CarsOfferProvider extends ChangeNotifier {
  CarsOfferList? carsOfferList;
  List<CarsOfferModel?>? carsOfferModel;

  bool refresh = false;
  bool get getRefresh => refresh;

  void setRefresh(bool value) {
    refresh = value;
    notifyListeners();
  }

  Future<CarsOfferList?> getCarOffer(BuildContext context) async {
    try {
      Map data = {"languageType": "en"};

      final response = await HttpService.post(Endpoints.getCarHotDeal, data);

      int status = response["statusCode"];
      var respData = response["data"];
      // print(respData);

      if (status == 200) {
        carsOfferList = CarsOfferList.fromJson(respData);
        carsOfferModel = carsOfferList!.data;
        notifyListeners();

        return carsOfferList;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
