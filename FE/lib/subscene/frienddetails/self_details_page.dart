import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zalo/subscene/frienddetails/footer/friend_detail_footer.dart';
import 'package:zalo/subscene/frienddetails/friend_detail_body.dart';
import 'package:zalo/subscene/frienddetails/header/friend_detail_header.dart';
import 'package:zalo/models/friend.dart';
import 'package:meta/meta.dart';
import 'package:zalo/subscene/frienddetails/header/self_detail_header.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SelfDetailsPage extends StatefulWidget {
  SelfDetailsPage(
    this.friend, {
    required this.avatarTag,
  });

  final Friend friend;
  final Object avatarTag;

  @override
  _SelfDetailsPageState createState() => new _SelfDetailsPageState();
}

class _SelfDetailsPageState extends State<SelfDetailsPage> {
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          Colors.white,
          Colors.white,
        ],
      ),
    );

    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          decoration: linearGradient,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new SelfDetailHeader(
                widget.friend,
                avatarTag: widget.avatarTag,
              ),
              new Padding(
                padding: const EdgeInsets.all(24.0),
                child: new FriendDetailBody(widget.friend),
              ),
              // new FriendShowcase(widget.friend),
            ],
          ),
        ),
      ),
    );
  }
}
