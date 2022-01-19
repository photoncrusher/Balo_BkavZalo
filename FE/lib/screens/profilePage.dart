import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zalo/models/login_info.dart';
import 'package:zalo/utils/storeService.dart';
import 'package:zalo/models/friend.dart';
import 'package:zalo/subscene/frienddetails/self_details_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  StoreService _storeService = StoreService();
  LoginInfo _user = LoginInfo.empty();
  String avatar = '';

  @override
  void initState() {
    super.initState();
    loadState();
  }

  List<DocumentSnapshot<Map<String, dynamic>>> data = [];

  Future<void> loadState() async {
    LoginInfo info = await _storeService.getLoginInfo();
    data = [
      await FirebaseFirestore.instance.collection('users').doc(info.id).get()
    ];
    setState(() {
      _user = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    Friend fr_temp = new Friend(
      avatar: data.isNotEmpty ? data[0].data()!['avatar'].toString() : '',
      name: _user.username,
      email: '',
      location: 'Ha noi',
    );
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            title: Text(_user.username),
            onTap: () => {
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (c) {
                    return new SelfDetailsPage(fr_temp,
                        avatarTag: data.isNotEmpty
                            ? data[0].data()!['avatar'].toString()
                            : '');
                  },
                ),
              )
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  data.isNotEmpty ? data[0].data()!['avatar'].toString() : ''),
              // child: _avatar == null ? Text(_username.substring(0, 1)) : null,
              // child: _user.avatar == null
              //     ? Text(_user.username.substring(0, 1))
              //     : null,
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
