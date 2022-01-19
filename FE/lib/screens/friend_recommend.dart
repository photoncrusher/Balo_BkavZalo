import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zalo/subscene/frienddetails/friend_details_page.dart';
import 'package:zalo/models/friend.dart';

class FriendsListPage extends StatefulWidget {
  @override
  _FriendsListPageState createState() => new _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  List<Friend> _friends = [];
  String _userid = "";

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  // Future<Map<String, dynamic>> loadState() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String jsonInfo = prefs.getString('login_info') ?? "{'user_id': ''}";
  //   Map<String, dynamic> userMap = json.decode(jsonInfo);
  //   setState(() {
  //     _userid = userMap['id'];
  //   });
  //   return userMap;
  // }

  Future<void> _loadFriends() async {
    // http.Response response =
    //     await http.get(Uri.parse("https://randomuser.me/api/?results=25"));
    final data = await FirebaseFirestore.instance.collection('users').get();
    List<Friend> _friends2 = [];
    // // duckfull_data = {'name': }

    data.docs.forEach((result) {
      var result_data = result.data();
      print(result_data);
      Friend fr_temp = new Friend(
        avatar: '',
        name: result_data['username'],
        email: result_data['phonenumber'],
        location: 'Ha noi',
      );
      _friends2.add(fr_temp);
      // print(_friends2);
    });
    setState(() {
      _friends = _friends2;
    });
  }

  Widget _buildFriendListTile(BuildContext context, int index) {
    var friend = _friends[index];

    return new ListTile(
      onTap: () => _navigateToFriendDetails(friend, index),
      leading: new Hero(
        tag: index,
        child: new CircleAvatar(
          backgroundImage: new NetworkImage(friend.avatar),
        ),
      ),
      title: new Text(friend.name),
      subtitle: new Text(friend.email),
    );
  }

  // void get_info()

  void _navigateToFriendDetails(Friend friend, Object avatarTag) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new FriendDetailsPage(friend, avatarTag: avatarTag);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_friends.isEmpty) {
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      content = new ListView.builder(
        itemCount: _friends.length,
        itemBuilder: _buildFriendListTile,
      );
    }

    return new Scaffold(
      body: content,
    );
  }
}
