import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  Storage._privateConstructor();

  static final Storage instance = Storage._privateConstructor();

  setStringValue(String key, String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

  Future<String> getStringValue(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key) ?? "";
  }

  setIntegerValue(String key, int value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(key, value);
  }

  Future<int> getIntegerValue(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(key) ?? 0;
  }

  setBooleanValue(String key, bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(key, value);
  }

  Future<bool> getBooleanValue(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(key) ?? false;
  }

  Future<bool> containsKey(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.containsKey(key);
  }

  removeValue(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove(key);
  }

  removeAll() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.clear();
  }
}
