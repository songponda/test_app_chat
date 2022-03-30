import 'package:global_configuration/global_configuration.dart';

class Endpoints {
  Endpoints._();

  static String signUpWithPhone =
      GlobalConfiguration().getValue("signUpWithPhone");
  static String requestOTP = GlobalConfiguration().getValue("requestOTP");
  static String verifyOTP = GlobalConfiguration().getValue("verifyOTP");
  static String getNews = GlobalConfiguration().getValue("getNews");
  static String getCarAll = GlobalConfiguration().getValue("getCarAll");
  static String getCarNew = GlobalConfiguration().getValue("getCarNew");
  static String getCarHotDeal = GlobalConfiguration().getValue("getCarHotDeal");
  static String profile = GlobalConfiguration().getValue("profile");
  static String getMR = GlobalConfiguration().getValue("getMR");
  static String getMRReward = GlobalConfiguration().getValue("getMRReward");
  static String registerMR = GlobalConfiguration().getValue("registerMR");
  static String getCarByCarId = GlobalConfiguration().getValue("getCarByCarId");
  static String getCarImageByCarImageId =
      GlobalConfiguration().getValue("getCarImageByCarImageId");
  static String checkStatusRegister =
      GlobalConfiguration().getValue("checkStatusRegister");
  static String feedback = GlobalConfiguration().getValue("feedback");
  static String referFriend = GlobalConfiguration().getValue("referFriend");
  static String sendNotificationTelegram =
      GlobalConfiguration().getValue("sendNotiTelegram");
  static String sendNotificationTelegramAndImage =
      GlobalConfiguration().getValue("sendNotiTelegramAndImage");
  static String saveLogFirstTime =
      GlobalConfiguration().getValue("saveLogFirstTime");
  static String updateRegister =
      GlobalConfiguration().getValue("updateRegister");
  static String editProfile = GlobalConfiguration().getValue("editProfile");
  static String editImageProfile =
      GlobalConfiguration().getValue("editImageProfile");
  static String getInterestUser =
      GlobalConfiguration().getValue("getInterestUser");
  static String getDropdownAddressAll =
      GlobalConfiguration().getValue("getDropdownAddressAll");
  static String getDropdownDistrict =
      GlobalConfiguration().getValue("getDropdownDistrict");
  static String getDropdownCareer =
      GlobalConfiguration().getValue("getDropdownCareer");
  static String saveToken = GlobalConfiguration().getValue("saveToken");
  static String updateToken = GlobalConfiguration().getValue("updateToken");
  static String checkTokenDuplicate =
      GlobalConfiguration().getValue("checkTokenDuplicate");
  static String getNotification =
      GlobalConfiguration().getValue("getNotification");
  static String loadNotificationStatus =
      GlobalConfiguration().getValue("loadNotificationStatus");
  static String loadNotificationStatusAll =
      GlobalConfiguration().getValue("loadNotificationStatusAll");
  static String insertNotificationStatus =
      GlobalConfiguration().getValue("insertNotificationStatus");
  static String updateNotificationStatus =
      GlobalConfiguration().getValue("updateNotificationStatus");
  static String updateAllNotificationStatus =
      GlobalConfiguration().getValue("updateAllNotificationStatus");
  static String updateReadAllNotificationStatus =
      GlobalConfiguration().getValue("updateReadAllNotificationStatus");
  static String updateDelNotificationStatus =
      GlobalConfiguration().getValue("updateDelNotificationStatus");
  static String uploadS3Center =
      GlobalConfiguration().getValue("uploadS3_Center");
  static String getTokenUserTest =
      GlobalConfiguration().getValue("getTokenUserTest");
  static String saveInterestUser =
      GlobalConfiguration().getValue("saveInterestUser");
}
