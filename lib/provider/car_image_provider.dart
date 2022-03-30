import 'package:flutter/material.dart';
import 'package:aicp/const/end_point.dart';
import 'package:aicp/service/http_service.dart';
import 'package:aicp/models/car_image_list.dart';
import 'package:aicp/models/car_image_model.dart';

class CarImageProvider extends ChangeNotifier {
  CarImageList? carImageList;
  List<CarImageModel?>? carImageModel;

  Future<CarImageList?> getCarImageDetail(
      BuildContext context, carImageId) async {
    try {
      Map data = {"carImageId": carImageId};
      print(carImageId);

      final response =
          await HttpService.post(Endpoints.getCarImageByCarImageId, data);

      int status = response["statusCode"];
      var respData = response["data"];

      if (status == 200) {
        carImageList = CarImageList.fromJson(respData);
        carImageModel = carImageList!.data;
        notifyListeners();
        return carImageList;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
