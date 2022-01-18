import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:zalo/constants/api_path.dart';
import 'package:zalo/utils/storeService.dart';

class BaseApi {
  BaseApi._privateConstructor();

  static final BaseApi _instance = BaseApi._privateConstructor();

  factory BaseApi() {
    return _instance;
  }
  StoreService _storeService = StoreService();

  Future<http.Response> request(Map<String, dynamic> data, String url) async {
    final uri = Uri.parse('${BASE_URL}${url}');
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=utf-8'
    };
    String? token = await _storeService.getToken();

    data['token'] = token;
    print(data);
    final res = await http.post(uri, headers: headers, body: jsonEncode(data));
    return res;
  }
}
