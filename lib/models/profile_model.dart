class ProfileModel {
  String? phone;
  String? phone_firebase;
  String? idcard;
  String? profile_img;
  String? firstname;
  String? lastname;
  String? fullname;
  String? adNumAddress;
  String? adMoo;
  String? adSoi;
  String? adTumbol;
  String? adAmp;
  String? adProvince;
  String? adZipcode;
  String? latitude;
  String? longtitude;
  String? branch_en;
  String? branch_km;
  String? career;
  String? birthDay;

  ProfileModel(
      {this.phone,
      this.phone_firebase,
      this.idcard,
      this.profile_img,
      this.firstname,
      this.lastname,
      this.fullname,
      this.adNumAddress,
      this.adMoo,
      this.adSoi,
      this.adTumbol,
      this.adAmp,
      this.adProvince,
      this.adZipcode,
      this.latitude,
      this.longtitude,
      this.branch_en,
      this.branch_km,
      this.career,
      this.birthDay});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
        phone: json["phone"] ?? '',
        phone_firebase: json["phone_firebase"] ?? '',
        idcard: json["idcard"] ?? '',
        profile_img: json["profile_img"] ?? '',
        firstname: json["firstname"] ?? '',
        lastname: json["lastname"] ?? '',
        fullname: json["fullname"] ?? '',
        adNumAddress: json["adNumAddress"] ?? '',
        adMoo: json["adMoo"] ?? '',
        adSoi: json["adSoi"] ?? '',
        adTumbol: json["adTumbol"] ?? '',
        adAmp: json["adAmp"] ?? '',
        adProvince: json["adProvince"] ?? '',
        adZipcode: json["adZipcode"] ?? '',
        latitude: json["latitude"] ?? '',
        longtitude: json["longtitude"] ?? '',
        branch_en: json["branch_en"] ?? '',
        branch_km: json["branch_km"] ?? '',
        career: json["career"] ?? '',
        birthDay: json["birthDay"] ?? '');
  }

  Map<String, dynamic> toMap() => {
        'phone': phone,
        'phone_firebase': phone_firebase,
        'idcard': idcard,
        'profile_img': profile_img,
        'firstname': firstname,
        'lastname': lastname,
        'fullname': fullname,
        'adNumAddress': adNumAddress,
        'adMoo': adMoo,
        'adSoi': adSoi,
        'adTumbol': adTumbol,
        'adAmp': adAmp,
        'adProvince': adProvince,
        'adZipcode': adZipcode,
        'latitude': latitude,
        'longtitude': longtitude,
        'branch_en': branch_en,
        'branch_km': branch_km,
        'career': career,
        'birthDay': birthDay,
      };
}
