import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zalo/apis/auth_api.dart';
import 'package:zalo/models/api_exception.dart';
import 'package:zalo/models/login_info.dart';
import 'package:zalo/screens/no_internet.dart';
import 'package:zalo/utils/auth_helper.dart';
import '../constants/error.dart';
import '../utils/check_connection.dart';

class LoginScreen extends StatefulWidget {
  final String? initPhoneNumber;
  const LoginScreen({Key? key, this.initPhoneNumber}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _LoginFormState extends State<LoginScreen> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final phoneNumber = TextEditingController();
  final password = TextEditingController();

  String _phoneNumber = '';
  String _password = '';
  String _errorMessage = '';
  bool _obscureText = false;

  AuthAPI _authAPI = AuthAPI();
  AuthHelper _authHelper = AuthHelper();

  @override
  void initState() {
    if (widget.initPhoneNumber != null)
      phoneNumber.text = widget.initPhoneNumber ?? "";
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    phoneNumber.dispose();
    password.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng nhập"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
            controller: phoneNumber,
            decoration: InputDecoration(
              labelText: 'Số điện thoại',
            ),
            keyboardType: TextInputType.phone,
          ),
          TextField(
              controller: password,
              obscureText: !_obscureText,
              decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _toggle();
                    },
                    child: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.red,
                    ),
                  ))),
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print("click");
          setErrorMessage('');
          _password = password.text;
          _phoneNumber = phoneNumber.text;
          String err = validator(_phoneNumber, _password);

          if (err.isNotEmpty) {
            print(err);
            setErrorMessage(err);
            return;
          }

          try {
            print('1');
            LoginInfo loginInfo = await _authAPI.login(_phoneNumber, _password);
            print('2');
            await saveInfo(loginInfo);
            print('3');
            Navigator.pushNamed(context, '/main');
          } on APIException catch (e) {
            print('${e.code} ${e.message}');
            if (e.code == '1004') {
              setErrorMessage('Sai mật khẩu');
              return;
            }
            setErrorMessage(ERROR[e.code] ?? "Có lỗi xảy ra");
          } catch (e) {
            print(e.toString());

            bool hasConnection =
                await ConnectionStatus.getInstance().checkConnection();
            if (!hasConnection) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoInternet((context) {
                            Navigator.pop(context);
                          })));
              return;
            }
            setErrorMessage('Lỗi ko xác định');
          }
          print('end click');
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Future<void> saveInfo(LoginInfo loginInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", loginInfo.token);
    prefs.setString("user_info", json.encode(loginInfo.toJson()));
  }

  void setErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  String validator(String phoneNumber, String password) {
    if (!_authHelper.checkPhoneNumber(phoneNumber)) {
      return "Số điện thoại không hợp lệ";
    }
    if (!_authHelper.checkPassword(password) || phoneNumber == password) {
      return "Mật khẩu phải từ 6 đến 10 kí tự và không được chứa kí tự đặc biệt";
    }
    return "";
  }
}
