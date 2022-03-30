import 'dart:io';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutService {
  static logout(context) async {
    /// clear preferences
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();

    /// clear secure storage
    const storage = FlutterSecureStorage();
    await storage.deleteAll();

    if (Platform.isAndroid) {
      /// clear  cacheDir
      final cacheDir = await getTemporaryDirectory();
      // print(cacheDir);
      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true);
      }
    }

    /// push first page restart
    Phoenix.rebirth(context);
  }
}
