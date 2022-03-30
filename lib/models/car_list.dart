import 'package:aicp/models/car_model.dart';

class CarsList {
  final List<CarsModel>? data;

  CarsList({this.data});

  factory CarsList.fromJson(List<dynamic> parsedJson) {
    List<CarsModel> data = <CarsModel>[];
    data = parsedJson.map((i) => CarsModel.fromJson(i)).toList();
    return CarsList(data: data);
  }
}
