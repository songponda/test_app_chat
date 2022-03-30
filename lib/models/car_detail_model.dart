class CarDetailModel {
  String? create_time;
  String? update_time;
  int? carID;
  String? carCode;
  String? carCodeFromBCT;
  String? carTitle;
  int? carPrice;
  int? carYear;
  int? carImageID;
  int? carMileage;
  String? carImageBanner;
  String? carColor;
  String? carBrandName;
  String? carBranchName;
  int? carCC;
  String? carCondition;
  String? carFuelName;
  String? carModel;
  String? carTransmissionName;
  String? carType;
  String? carDetails;

  CarDetailModel(
      {this.create_time,
      this.update_time,
      this.carID,
      this.carCode,
      this.carCodeFromBCT,
      this.carTitle,
      this.carPrice,
      this.carYear,
      this.carImageID,
      this.carMileage,
      this.carImageBanner,
      this.carColor,
      this.carBrandName,
      this.carBranchName,
      this.carCC,
      this.carCondition,
      this.carFuelName,
      this.carModel,
      this.carTransmissionName,
      this.carType,
      this.carDetails});

  factory CarDetailModel.fromJson(Map<String, dynamic> json) {
    return CarDetailModel(
        create_time: json["create_time"] ?? '',
        update_time: json["update_time"] ?? '',
        carID: json["carID"] ?? '',
        carCode: json["carCode"] ?? '',
        carCodeFromBCT: json["carCodeFromBCT"] ?? '',
        carTitle: json["carTitle"] ?? '',
        carPrice: json["carPrice"] ?? '',
        carYear: json["carYear"] ?? '',
        carImageID: json["carImageID"] ?? '',
        carMileage: json["carMileage"] ?? '',
        carImageBanner: json["carImageBanner"] ?? '',
        carColor: json["carColor"] ?? '',
        carBrandName: json["carBrandName"] ?? '',
        carBranchName: json["carBranchName"] ?? '',
        carCC: json["carCC"] ?? '',
        carCondition: json["carCondition"] ?? '',
        carFuelName: json["carFuelName"] ?? '',
        carModel: json["carModel"] ?? '',
        carTransmissionName: json["carTransmissionName"] ?? '',
        carType: json["carType"] ?? '',
        carDetails: json["carDetails"] ?? '');
  }

  Map<String, dynamic> toMap() => {
        'create_time': create_time,
        'update_time': update_time,
        'carID': carID,
        'carCode': carCode,
        'carCodeFromBCT': carCodeFromBCT,
        'carTitle': carTitle,
        'carPrice': carPrice,
        'carYear': carYear,
        'carImageID': carImageID,
        'carMileage': carMileage,
        'carImageBanner': carImageBanner,
        'carColor': carColor,
        'carBrandName': carBrandName,
        'carBranchName': carBranchName,
        'carCC': carCC,
        'carCondition': carCondition,
        'carFuelName': carFuelName,
        'carModel': carModel,
        'carTransmissionName': carTransmissionName,
        'carType': carType,
        'carDetails': carDetails
      };
}
