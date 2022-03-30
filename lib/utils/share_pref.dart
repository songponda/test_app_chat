import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static save(String key, var value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static readValue(type, name) async {
    var value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    type == 'int'
        ? value = await prefs.getInt(name)
        : type == 'string'
            ? value = await prefs.getString(name)
            : value = await prefs.getBool(name);

    return value;
  }

  static setValue(type, name, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    type == 'int'
        ? await prefs.setInt(name, value)
        : type == 'string'
            ? await prefs.setString(name, value)
            : await prefs.setBool(name, value);
  }

  static remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
