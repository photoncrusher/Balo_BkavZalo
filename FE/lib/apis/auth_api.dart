import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zalo/constants/api_path.dart';
import 'package:zalo/models/api_exception.dart';
import 'package:zalo/models/login_info.dart';

class AuthAPI {
  AuthAPI._privateConstructor();

  static final AuthAPI _instance = AuthAPI._privateConstructor();

  factory AuthAPI() {
    return _instance;
  }

  Future<LoginInfo> login(String phoneNumber, String password) async {
    final uri = Uri.parse(BASE_URL + '/login');
    final data = {'phonenumber': phoneNumber, 'password': password};
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8'
    };
    final res = await http.post(uri, headers: headers, body: jsonEncode(data));
    final jsonData = jsonDecode(res.body);
    print(res.statusCode);
    print(res.body);
    if (res.statusCode >= 400) {
      throw APIException.fromJson(jsonData);
    }
    return LoginInfo.fromJson(jsonData['data']);
  }

  Future<void> signUp(
      String name, String phoneNumber, String password, String uuid) async {
    final uri = Uri.parse(BASE_URL + '/signup');
    final data = {
      'username': name,
      'phonenumber': phoneNumber,
      'password': password,
      'uuid': uuid
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8'
    };

    final res = await http.post(uri, headers: headers, body: jsonEncode(data));
    final jsonData = jsonDecode(res.body);

    if (res.statusCode >= 400) {
      throw APIException.fromJson(jsonData);
    }
  }
}
