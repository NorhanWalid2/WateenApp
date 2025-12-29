import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedpreference;

  init() async {
    sharedpreference = await SharedPreferences.getInstance();
  }

  String? getDataString({required String key}) {
    return sharedpreference.getString(key);
  }

  Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is bool) {
      return await sharedpreference.setBool(key, value);
    }
    if (value is String) {
      return await sharedpreference.setString(key, value);
    }
    if (value is int) {
      return await sharedpreference.setInt(key, value);
    } else {
      return await sharedpreference.setDouble(key, value);
    }
  }

  dynamic getData({required String key}) {
    return sharedpreference.get(key);
  }

  Future<bool> removeData({required String key}) async {
    return await sharedpreference.remove(key);
  }

  Future<bool> containsKey({required String key}) async {
    return sharedpreference.containsKey(key);
  }

  Future<bool> clearAll() async {
    return sharedpreference.clear();
  }
}
