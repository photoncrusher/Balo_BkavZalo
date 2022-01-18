import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:zalo/apis/auth_api.dart';
import 'package:zalo/constants/error.dart';
import 'package:zalo/models/api_exception.dart';
import 'package:zalo/screens/no_internet.dart';
import 'package:zalo/screens/register/confirm_register.dart';
import 'package:zalo/screens/register/user_exist.dart';
import 'package:zalo/utils/auth_helper.dart';
import 'package:zalo/utils/check_connection.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _RegisterFormState extends State<RegisterScreen> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  // final verifyPasswordController = TextEditingController();

  String _errorMessage = '';
  bool _obscureText = false;

  AuthHelper _authHelper = AuthHelper();
  AuthAPI _authAPI = AuthAPI();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    phoneNumberController.dispose();
    passwordController.dispose();
    nameController.dispose();
    // verifyPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng ký"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Tên',
              )),
          TextField(
            controller: phoneNumberController,
            decoration: InputDecoration(
              labelText: 'Số điện thoại',
            ),
            keyboardType: TextInputType.phone,
          ),
          TextField(
              controller: passwordController,
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
          // TextField(
          //     controller: verifyPasswordController,
          //     obscureText: true,
          //     decoration: InputDecoration(
          //       labelText: 'Nhập lại mật khẩu',
          //     )),
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
          setErrorMessage('');
          String name = nameController.text;
          String phoneNumber = phoneNumberController.text;
          String password = passwordController.text;
          // String verifyPassword = verifyPasswordController.text;
          // String err = validatorRegisterInfo(phoneNumber, password, password);

          // if (err.isNotEmpty) {
          //   print(err);
          //   setErrorMessage(err);
          //   return;
          // }

          String uuid = await getDeviceID();
          if (uuid.isEmpty) uuid = 'NoId';
          print(uuid);
          try {
            await _authAPI.signUp(name, phoneNumber, password, uuid);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ConfirmRegisterScreen(phoneNumber: phoneNumber)));
          } on APIException catch (e) {
            if (e.code == '9996') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserExistScreen(
                            phoneNumber: phoneNumber,
                          )));
              return;
            }
            setErrorMessage(ERROR[e.code] ?? "Có lỗi xảy ra");
          } catch (e) {
            print(e);
            bool hasConnection =
                await ConnectionStatus.getInstance().checkConnection();
            if (!hasConnection) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoInternet((BuildContext context) {
                            Navigator.pop(context);
                          })));
              return;
            }
            setErrorMessage('Lỗi ko xác định');
          }
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String validatorRegisterInfo(
      String phoneNumber, String password, String verifyPassword) {
    if (!_authHelper.checkPhoneNumber(phoneNumber)) {
      return "Số điện thoại không hợp lệ";
    }
    if (!_authHelper.checkPassword(password) || phoneNumber == password) {
      return "Mật khẩu phải từ 6 đến 10 kí tự và không được chứa kí tự đặc biệt";
    }
    if (password != verifyPassword) {
      return "Mật khẩu không khớp";
    }
    return "";
  }

  void setErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  Future<String> getDeviceID() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    String uuid = '';
    try {
      if (Platform.isAndroid) {
        var info = await deviceInfoPlugin.androidInfo;
        uuid = info.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var info = await deviceInfoPlugin.iosInfo;
        uuid = info.identifierForVendor; //UUID for iOS
      }
    } on Exception {
      print("Can't get device id");
    } catch (err) {
      print(err);
    }
    return uuid;
  }
}
