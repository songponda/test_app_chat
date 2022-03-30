import 'package:aicp/models/car_offer_model.dart';

class CarsOfferList {
  final List<CarsOfferModel>? data;

  CarsOfferList({this.data});

  factory CarsOfferList.fromJson(List<dynamic> parsedJson) {
    List<CarsOfferModel> data = <CarsOfferModel>[];
    data = parsedJson.map((i) => CarsOfferModel.fromJson(i)).toList();
    return CarsOfferList(data: data);
  }
}
