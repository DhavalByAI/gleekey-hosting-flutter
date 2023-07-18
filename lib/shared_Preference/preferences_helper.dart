import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static String Token = 'Token';
  static String user_id = 'User_ID';
  static String email = 'Email';
  static String password = 'Password';

  Future setPreferencesStringData(String Key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(Key, value).then((data) => debugPrint('$data'));
  }

  Future<String?> getPreferencesStringData(String Key) async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(Key);
    return value;
  }

  Future setPreferencesIntData(String Key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(Key, value).then((data) => debugPrint('$data'));
  }

  Future<int?> getPreferencesIntData(String Key) async {
    final prefs = await SharedPreferences.getInstance();
    int? value = prefs.getInt(Key);
    return value;
  }

  Future setPreferencesBoolData(String Key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(Key, value).then((data) => debugPrint('$data'));
  }

  Future<bool?> getPreferencesBoolData(String Key) async {
    final prefs = await SharedPreferences.getInstance();
    bool? value = prefs.getBool(Key);
    return value ?? false;
  }

  Future clearPreferenceData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
