/**
 * @author Akshit Jha
 * Creation Date: 12-12-2024
 */

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  late SharedPreferences _pref;
  final Future<SharedPreferences> _prefFuture = SharedPreferences.getInstance();

  Future<void> init() async {
    _pref = await _prefFuture;
  }

  Preferences() {
    init();
  }

  getBool(String key) {
    return _pref.getBool(key);
  }

  getDouble(String key) {
    return _pref.getDouble(key);
  }

  getInt(String key) {
    return _pref.getInt(key);
  }

  getString(String key) {
    return _pref.getString(key);
  }

  List<String>? getStringList(String key) {
    return _pref.getStringList(key);
  }

  Future<bool> setBool(String key, bool value) {
    return _pref.setBool(key, value);
  }

  Future<bool> setDouble(String key, double value) {
    return _pref.setDouble(key, value);
  }

  Future<bool> setInt(String key, int value) {
    return _pref.setInt(key, value);
  }

  Future<bool> setString(String key, String value) {
    return _pref.setString(key, value);
  }

  Future<bool> setStringList(String key, List<String> value) {
    return _pref.setStringList(key, value);
  }

  Future<bool> clearAll() {
    return _pref.clear();
  }

  Future<bool> remove(String key) {
    return _pref.remove(key);
  }
}
