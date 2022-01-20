import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:zalo/models/friend.dart';
import 'package:zalo/subscene/frienddetails/friend_details_page.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool typing = false;

  // late Timer _debounce;
  List<dynamic> new_data = [];
  List<Friend> _friends = [];
  var data;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  void _loadFriends() {
    List<Friend> _friends2 = [];
    data = new_data.isEmpty ? null : new_data[0];
    print(data);
    if (data != null)
      data.docs.forEach((result) {
        var result_data = result.data();
        Friend fr_temp = new Friend(
          avatar: result_data['avatar'] ?? '',
          name: result_data['username'],
          email: result_data['phonenumber'],
          location: 'Ha noi',
        );
        _friends2.add(fr_temp);
      });
    if (data == null) _friends2 = [];
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

  void _navigateToFriendDetails(Friend friend, Object avatarTag) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new FriendDetailsPage(friend, avatarTag: avatarTag);
        },
      ),
    );
  }

  _onSearchChanged(String query) {
    if (query.isEmpty) {
      query = '';
    }
    EasyDebounce.debounce(
        'my-debouncer', // <-- An ID for this particular debouncer
        Duration(milliseconds: 500), // <-- The debounce duration
        () async {
      data = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('username')
          .startAt([query]).endAt([query + '\uf8ff']).get();
      setState(() {
        new_data = [data];
        _loadFriends();
      });
      // print(
      //     new_data.isEmpty ? 'empty' : new_data[0].docs[0].data()['username']);
    });
  }

  @override
  void dispose() {
    EasyDebounce.cancelAll();
    super.dispose();
  }

  // var data;
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
    return Scaffold(
        appBar: AppBar(
          title: Container(
            alignment: Alignment.centerLeft,
            color: Colors.white,
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Tìm bạn bè theo tên'),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.qr_code, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        body: content);
  }
}

// class TextBox extends StatelessWidget {
//   // late QuerySnapshot<Map<String, dynamic>> data;
//   var data;
//   @override
//   Widget build(BuildContext context) {
//     return 
//   }
// }
