import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zalo/screens/chatDetail.dart';
import 'package:zalo/subscene/frienddetails/header/diagonally_cut_colored_image.dart';
import 'package:zalo/models/friend.dart';

class FriendDetailHeader extends StatelessWidget {
  static const BACKGROUND_IMAGE = 'images/profile_picture_bg.jpg';

  FriendDetailHeader(
    this.friend, {
    required this.avatarTag,
  });

  final Friend friend;
  final Object avatarTag;

  Widget _buildDiagonalImageBackground(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return new DiagonallyCutColoredImage(
      new Image.asset(
        BACKGROUND_IMAGE,
        width: screenWidth,
        height: 280.0,
        fit: BoxFit.cover,
      ),
      color: const Color(0xBB8338f4),
    );
  }

  Widget _buildAvatar() {
    return new Hero(
      tag: avatarTag,
      child: new CircleAvatar(
        backgroundImage: new NetworkImage(friend.avatar),
        radius: 50.0,
      ),
    );
  }

  Widget _buildFollowerInfo(TextTheme textTheme) {
    var followerStyle =
        textTheme.subtitle1!.copyWith(color: const Color(0xBBFFFFFF));

    return new Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            friend.name,
            style: textTheme.headline6!.copyWith(color: Colors.white),
          ),
          // new Text('90 bạn chung', style: followerStyle),
        ],
      ),
    );
  }

  // Future<Map<String, dynamic>> load_rooms(String email) async {

  //   // setState(() {
  //   //   _id = userMap['id'];
  //   // });
  //   // data.docs.forEach((element) {
  //   //   print(element.data()['id']);
  //   // });
  //   return data.docs[0].data();
  // }

  // Widget _buildActionButtons(ThemeData theme) {
  //   return new

  Widget _createPillButton(
    String text, {
    Color backgroundColor = Colors.transparent,
    Color textColor = Colors.white70,
  }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),
      child: new MaterialButton(
        minWidth: 140.0,
        color: backgroundColor,
        textColor: textColor,
        onPressed: () {
          // return ChatDetailPage(name: friend.email);
        },
        child: new Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return new Stack(
      children: <Widget>[
        _buildDiagonalImageBackground(context),
        new Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1.4,
          child: new Column(
            children: <Widget>[
              _buildAvatar(),
              _buildFollowerInfo(textTheme),
              // _buildActionButtons(theme),
              ClipRRect(
                borderRadius: new BorderRadius.circular(30.0),
                child: new MaterialButton(
                  minWidth: 140.0,
                  color: Colors.transparent,
                  textColor: Colors.white70,
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String jsonInfo =
                        prefs.getString('login_info') ?? "{'user_id': ''}";
                    Map<String, dynamic> userMap = json.decode(jsonInfo);
                    final data = await FirebaseFirestore.instance
                        .collection('chat_rooms')
                        .where('people_array', whereIn: [
                      [userMap['id'], friend.email],
                      [friend.email, userMap['id']]
                    ]).get();
                    String _id = "";
                    if (data.docs.isNotEmpty) {
                      _id = data.docs[0].data()['id'].toString();
                    } else {
                      DocumentReference docRef = await FirebaseFirestore
                          .instance
                          .collection('chat_rooms')
                          .doc();
                      await docRef.set({
                        'id': docRef.id,
                        'message': [], // John Doe
                        'people': [
                          {'name': userMap['usename'], 'id': userMap['id']},
                          {'name': friend.name, 'id': friend.email}
                        ], // Stokes and Sons
                        'people_array': [userMap['id'], friend.email] // 42
                      });
                      final data2 = await FirebaseFirestore.instance
                          .collection('chat_rooms')
                          .where('people_array', whereIn: [
                        [userMap['id'], friend.email],
                        [friend.email, userMap['id']]
                      ]).get();
                      _id = data2.docs[0].data()['id'].toString();
                      // print(_id);
                    }

                    Navigator.push(context, MaterialPageRoute(builder: (
                      context,
                    ) {
                      return ChatDetailPage(name: _id);
                    }));
                  },
                  child: new Text('Tin nhan'),
                ),
              ),
            ],
          ),
        ),
        new Positioned(
          top: 26.0,
          left: 4.0,
          child: new BackButton(color: Colors.white),
        ),
      ],
    );
  }
}
