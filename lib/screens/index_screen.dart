import 'package:aicp/const/pref_data.dart';
import 'package:aicp/service/logout_service.dart';
import 'package:aicp/utils/share_pref.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:aicp/screens/home_screen.dart';
import 'package:aicp/screens/product_screen.dart';
import 'package:aicp/screens/profile_screen.dart';
import 'package:aicp/themes/app_colors.dart';
import 'package:aicp/screens/mr_reward_screen.dart';
import 'package:aicp/screens/mr_screen.dart';
import 'package:aicp/const/end_point.dart';
import 'package:aicp/const/secure_data.dart';
import 'package:aicp/service/http_service.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({Key? key}) : super(key: key);

  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  int _currentTabIndex = 0;
  late bool statusMR = false;
  late bool registerStatus;

  @override
  void initState() {
    super.initState();
    checkStatusRegister();
    getMRStatus();
  }

  Future checkStatusRegister() async {
    try {
      const storage = FlutterSecureStorage();
      String? accessTokenStorage =
          await storage.read(key: SecureData.accessToken);
      String? userIdStorage = await storage.read(key: SecureData.userId);
      registerStatus =
          await SharedPref.readValue('bool', Preferences.registerStatus);
      print('registerStatus is ${registerStatus}');

      if (accessTokenStorage != null && userIdStorage != null) {
        Map data = {"userId": userIdStorage, "accessToken": accessTokenStorage};

        final response =
            await HttpService.post(Endpoints.checkStatusRegister, data);

        int status = response["statusCode"];
        var res = response["data"][0];
        print(response);
        print(status);
        print(res);

        if (status == 200 && res != null) {
          if (res["statusRegister"] == "N") {
            await SharedPref.setValue(
                'bool', Preferences.registerStatus, false);
          } else if (res["statusRegister"] == "Y") {
            await SharedPref.setValue('bool', Preferences.registerStatus, true);
          }
        } else if (status == 401) {
          print("Unauthorized -> Logout!");
          LogoutService.logout(context);
        } else if (status == 404) {
          /// ไม่เจอข้อมูล Profile User
          print("Get Status Failed , อื่น ๆ ติดต่อ Admin , ");
          // return null;
        } else {
          print("Error อื่น ๆ ติดต่อ Admin , และ ส่งข้อมูล Error ");
          // return null;
        }
      } else {
        await SharedPref.setValue('bool', Preferences.registerStatus, false);
        print('Secure Storeage is Empty!');
      }
    } catch (e) {
      print("Error อื่น ๆ ติดต่อ Admin , และ ส่งข้อมูล Error ");
      // return null;
    }
  }

  void getMRStatus() async {
    try {
      const storage = FlutterSecureStorage();
      String? accessTokenStorage =
          await storage.read(key: SecureData.accessToken);
      String? userIdStorage = await storage.read(key: SecureData.userId);

      Map data = {"userId": userIdStorage, "accessToken": accessTokenStorage};

      final response = await HttpService.post(Endpoints.getMR, data);

      // print(response);

      int status = response["statusCode"];
      var res = response["data"][0];

      if (status == 200 && res != null && res['ID_MR'] != null) {
        setState(() {
          statusMR = true;
        });
      } else if (status == 401) {
        print("Unauthorized -> Logout!");
        LogoutService.logout(context);
      } else if (status == 404) {
        print("ต้องสมัคร MR");
        setState(() {
          statusMR = false;
        });
      } else {
        print("Error อื่น ๆ ติดต่อ Admin , และ ส่งข้อมูล Error ");
        // Alert.popupAlertErrorContactAdmin(context);
      }
    } catch (e) {
      print(e);
      print("Error! From Server");
      // Alert.popupAlertErrorContactAdmin(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _kTabPages = [
      const HomeScreen(),
      const ProductScreen(),
      statusMR == true ? const MRRewardScreen() : const MRScreen(),
      const ProfileScreen()
    ];

    final _kBottomNavBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const FaIcon(
          FontAwesomeIcons.home,
          size: 23.0,
        ),
        label: 'home'.tr(),
      ),
      BottomNavigationBarItem(
        icon: const FaIcon(
          FontAwesomeIcons.motorcycle,
          size: 23.0,
        ),
        label: 'products'.tr(),
      ),
      BottomNavigationBarItem(
        icon: const FaIcon(
          FontAwesomeIcons.userFriends,
          size: 23.0,
        ),
        label: 'mr'.tr(),
      ),
      BottomNavigationBarItem(
        icon: const FaIcon(
          FontAwesomeIcons.solidUser,
          size: 23.0,
        ),
        label: 'profile'.tr(),
      ),
    ];
    assert(_kTabPages.length == _kBottomNavBarItems.length);
    final bottomNavBar = BottomNavigationBar(
      unselectedFontSize: 13,
      unselectedItemColor: AppColors.indigoTran.withOpacity(0.5),
      selectedItemColor: AppColors.white,
      backgroundColor: AppColors.indigoPrimary,
      items: _kBottomNavBarItems,
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          _currentTabIndex = index;
        });
      },
    );
    return Scaffold(
      body: _kTabPages[_currentTabIndex],
      bottomNavigationBar: SizedBox(
        height: 97,
        child: bottomNavBar,
      ),
      // bottomNavigationBar: bottomNavBar,
    );
  }
}
