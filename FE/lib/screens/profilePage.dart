import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zalo/models/login_info.dart';
import 'package:zalo/utils/storeService.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  StoreService _storeService = StoreService();
  late String _username = "A";
  String? _avatar;

  @override
  void initState() {
    loadState();
    super.initState();
  }

  void loadState() async {
    LoginInfo info = await _storeService.getLoginInfo();
    setState(() {
      _username = info.username;
      _avatar = info.avatar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            title: Text(_username),
            onTap: () {},
            leading: CircleAvatar(
              backgroundImage:
                  _avatar != null ? NetworkImage(_avatar ?? '') : null,
              child: _avatar == null ? Text(_username.substring(0, 1)) : null,
              radius: 20.0,
            ),
          ),
          // ListTile(title: Text("Ví QR"), onTap: () {}),
          // ListTile(title: Text("Cloud của tôi"), onTap: () {}),
          ListTile(title: Text("Tài khoản và bảo mật"), onTap: () {}),
          // ListTile(title: Text("Quyền riêng tư"), onTap: () {}),
          ListTile(
            title: Text("Đăng xuất"),
            onTap: () async {
              await deleteInfo();
              Navigator.pushNamedAndRemoveUntil(
                  context, "/", ModalRoute.withName('/'));
            },
          ),
        ],
      ),
    ));
  }

  Future<void> deleteInfo() async {
    await _storeService.clearStore();
  }
}
