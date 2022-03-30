class CarsModel {
  String? update_time;
  String? create_time;
  int? carID;
  String? carCode;
  String? carCodeFromBCT;
  String? carTitle;
  String? carDetails;
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

  CarsModel(
      {this.update_time,
      this.create_time,
      this.carID,
      this.carCode,
      this.carCodeFromBCT,
      this.carTitle,
      this.carDetails,
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
      this.carType});

  factory CarsModel.fromJson(Map<String, dynamic> json) {
    return CarsModel(
        update_time: json["update_time"],
        create_time: json["create_time"],
        carID: json["carID"] ?? '',
        carCode: json["carCode"] ?? '',
        carCodeFromBCT: json["carCodeFromBCT"] ?? '',
        carTitle: json["carTitle"] ?? '',
        carDetails: json["carDetails"] ?? '',
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
        carType: json["carType"] ?? '');
  }

  Map<String, dynamic> toMap() => {
        'update_time': update_time,
        'create_time': create_time,
        'carID': carID,
        'carCode': carCode,
        'carCodeFromBCT': carCodeFromBCT,
        'carTitle': carTitle,
        'carDetails': carDetails,
        'carPrice': carPrice,
        'carYear': carYear,
        'carImageID': carImageID,
        'carMileage': carMileage,
        'carImageBanner': carImageBanner,
        'carColorEN': carColor,
        'carBrandName': carBrandName,
        'carBranchName': carBranchName,
        'carCC': carCC,
        'carCondition': carCondition,
        'carFuelName': carFuelName,
        'carModel': carModel,
        'carTransmissionName': carTransmissionName,
        'carType': carType
      };
}
