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
  LoginInfo _user =
      LoginInfo(id: "None", token: "None", active: false, username: "A");

  @override
  void initState() {
    super.initState();
    loadState();
  }

  Future<void> loadState() async {
    LoginInfo info = await _storeService.getLoginInfo();
    setState(() {
      _user = info;
    });
  }

  // void loadState() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String jsonInfo =
  //       prefs.getString('user_info') ?? "{'username': 'Anonymous'}";

  //   Map<String, dynamic> userMap = json.decode(jsonInfo);
  //   print(userMap);
  //   setState(() {
  //     _username = userMap['usename'] ?? 'Anonymous';
  //     _avatar = userMap['avatar'];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //     body: SingleChildScrollView(
    //         child: Column(children: <Widget>[
    //   Container(
    //       height: 360.0,
    //       child: Stack(children: <Widget>[
    //         Container(
    //           margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
    //           height: 180.0,
    //           decoration: BoxDecoration(
    //               image: DecorationImage(
    //                   image: AssetImage('assets/zalo002.jpg'),
    //                   fit: BoxFit.cover),
    //               borderRadius: BorderRadius.circular(10.0)),
    //         ),
    //         Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
    //           CircleAvatar(
    //             backgroundImage: AssetImage('images/beluwa.jpg'),
    //             radius: 70.0,
    //           ),
    //           SizedBox(height: 20.0),
    //           Text('Duy Quang',
    //               style:
    //                   TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
    //           SizedBox(height: 20.0)
    //         ])
    //       ]))
    // ])));
    Friend fr_temp = new Friend(
      avatar: '',
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
                    return new SelfDetailsPage(fr_temp, avatarTag: '');
                  },
                ),
              )
            },
            leading: CircleAvatar(
              backgroundImage: _user.avatar != null
                  ? NetworkImage(_user.avatar ?? '')
                  : null,
              // child: _avatar == null ? Text(_username.substring(0, 1)) : null,
              child: _user.avatar == null
                  ? Text(_user.username.substring(0, 1))
                  : null,
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
