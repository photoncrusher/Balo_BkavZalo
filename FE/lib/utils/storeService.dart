import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zalo/models/login_info.dart';

class StoreService {
  StoreService._privateConstructor();
  static final StoreService _instance = StoreService._privateConstructor();
  factory StoreService() {
    return _instance;
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  Future<void> saveLoginInfo(LoginInfo loginInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(json.encode(loginInfo.toJson()));
    prefs.setString("login_info", json.encode(loginInfo.toJson()));
  }

  Future<LoginInfo> getLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString =
        prefs.getString("login_info") ?? "{'username': 'Anonymous'}";
    Map<String, dynamic> infoMap = json.decode(jsonString);
    return LoginInfo.fromJson(infoMap);
  }

  Future<void> clearStore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.remove("login_info");
  }
}
