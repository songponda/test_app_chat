class CarImageModel {
  int? carImageID;
  String? linkCarImage;
  String? statusDisableImage;

  CarImageModel({this.carImageID, this.linkCarImage, this.statusDisableImage});

  factory CarImageModel.fromJson(Map<String, dynamic> json) {
    return CarImageModel(
        carImageID: json["carImageID"],
        linkCarImage: json["linkCarImage"],
        statusDisableImage: json["statusDisableImage"] ?? '');
  }

  Map<String, dynamic> toMap() => {
        'carImageID': carImageID,
        'linkCarImage': linkCarImage,
        'statusDisableImage': statusDisableImage
      };
}
