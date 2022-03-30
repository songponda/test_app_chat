import 'dart:io';

class GetOSService {
  static getOS() {
    String os = Platform.operatingSystem;

    return os;
  }
}
