import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool?> setData({required String key, required value}) async {
    if (value is bool) {
      await sharedPreferences?.setBool(key, value);
      return true;
    }

    if (value is int) {
      await sharedPreferences?.setInt(key, value);
      return true;
    }

    if (value is double) {
      await sharedPreferences?.setDouble(key, value);
      return true;
    }

    if (value is String) {
      await sharedPreferences?.setString(key, value);
      return true;
    }


    return false;
  }

  static dynamic getData({required String key}) {
    return sharedPreferences?.get(key);
  }
  static dynamic deleteData({required String key}){
    sharedPreferences?.remove(key);
  }
}
