

import 'package:shared_preferences/shared_preferences.dart';

abstract class CacheService {
  static late SharedPreferences _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> setData({required String key, required dynamic value})async {
    if (value is String) {
     await _sharedPreferences.setString(key, value);
    } else if (value is int) {
     await _sharedPreferences.setInt(key, value);
    } else if (value is bool) {
     await _sharedPreferences.setBool(key, value);
    } else if (value is double) {
     await _sharedPreferences.setDouble(key, value);
    } else {
     await _sharedPreferences.setStringList(key, value);
    }
  }

  static String? getString({required String key}) {
    return _sharedPreferences.getString(key) ;
  }

  static int getInt({required String key}) {
    return _sharedPreferences.getInt(key) ?? 0;
  }

  //double
  static double getDouble({required String key}) {
    return _sharedPreferences.getDouble(key) ?? 0.0;
  }

  static bool getBool({required String key}) {
    return _sharedPreferences.getBool(key) ?? false;
  }

  //remove
  static void remove({required String key}) {
    _sharedPreferences.remove(key);
  }

  static List<String> getStringList({required String key}) {
    return _sharedPreferences.getStringList(key) ?? [];
  }

  static void clear() {
    _sharedPreferences.clear();
  }
}