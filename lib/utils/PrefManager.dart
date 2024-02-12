import 'package:shared_preferences/shared_preferences.dart';

import 'Constants.dart';

class PrefManager {
  static void putString(String key,String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value  = prefs.getString(key)!;
    return value;
  }

  static void putBool(String key,bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static Future<bool> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(key)!;
    return value;
  }


  static void setLang(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstant.lang, value);
  }

  static Future<String> getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value  = prefs.getString(AppConstant.lang)!;
    return value.isEmpty?"en" :value;
  }

  static void clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

}