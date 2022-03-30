import 'package:aicp/models/car_image_model.dart';

class CarImageList {
  final List<CarImageModel>? data;

  CarImageList({this.data});

  factory CarImageList.fromJson(List<dynamic> parsedJson) {
    List<CarImageModel> data = <CarImageModel>[];
    data = parsedJson.map((i) => CarImageModel.fromJson(i)).toList();
    return CarImageList(data: data);
  }
}
