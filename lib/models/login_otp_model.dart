class LoginOtp {
  String? refCode;

  LoginOtp({this.refCode});

  factory LoginOtp.fromJson(Map<String, dynamic> json) =>
      LoginOtp(refCode: json["refCode"]);

  Map<String, dynamic> toJson() {
    return {'refCode': refCode};
  }
}
