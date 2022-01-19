import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zalo/subscene/frienddetails/header/diagonally_cut_colored_image.dart';
import 'package:zalo/models/friend.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SelfDetailHeader extends StatefulWidget {
  SelfDetailHeader(
    this.friend, {
    required this.avatarTag,
  });

  final Friend friend;
  final Object avatarTag;

  @override
  _SelfDetailHeaderState createState() => new _SelfDetailHeaderState();
}

class _SelfDetailHeaderState extends State<SelfDetailHeader> {
  static const BACKGROUND_IMAGE = 'images/profile_picture_bg.jpg';
  late File _imageFile;
  String _userid = "";
  final picker = ImagePicker();
  Future<Map<String, dynamic>> loadState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonInfo = prefs.getString('login_info') ?? "{'user_id': ''}";
    Map<String, dynamic> userMap = json.decode(jsonInfo);
    setState(() {
      _userid = userMap['id'];
    });
    return userMap;
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future pickImage2() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(_imageFile.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    try {
      await loadState();
      await firebaseStorageRef.putFile(_imageFile).whenComplete(() => null);
      firebaseStorageRef.getDownloadURL().then((value) => {
            FirebaseFirestore.instance
                .collection('users')
                .doc(_userid)
                .update({"avatar": value.toString()})
          });
    } on FirebaseException catch (e) {}
    ;
  }

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

  Widget _buildAvatar(context) {
    return new Hero(
        tag: widget.avatarTag,
        child: new GestureDetector(
          // onTap: () => pickImage(),
          // onTap: () {
          //   return Dialog(
          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          //       elevation: 16,
          //       child: Container()
          //   );
          // },
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return new Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      elevation: 16,
                      insetPadding: EdgeInsets.fromLTRB(50, 200, 50, 200),
                      child: Column(children: [
                        ListTile(
                            title: Text("Chụp ảnh mới"),
                            onTap: () {
                              pickImage()
                                  .then((value) =>
                                      {uploadImageToFirebase(context)})
                                  .then((value) => {print(value)});
                            }),
                        ListTile(
                            title: Text("Chọn ảnh từ máy"),
                            onTap: () {
                              pickImage2().then(
                                  (value) => {uploadImageToFirebase(context)});
                            }),
                      ]));
                });
          },
          child: CircleAvatar(
            backgroundImage: new NetworkImage(widget.friend.avatar),
            radius: 50.0,
          ),
        ));
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
            widget.friend.name,
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
              _buildAvatar(context),
              _buildFollowerInfo(textTheme),
              // _buildActionButtons(theme),
              // ClipRRect(
              //   borderRadius: new BorderRadius.circular(30.0),
              //   child: new MaterialButton(
              //     minWidth: 140.0,
              //     color: Colors.transparent,
              //     textColor: Colors.white70,
              //     onPressed: () async {
              //       SharedPreferences prefs =
              //           await SharedPreferences.getInstance();
              //       String jsonInfo =
              //           prefs.getString('login_info') ?? "{'user_id': ''}";
              //       Map<String, dynamic> userMap = json.decode(jsonInfo);
              //       final data = await FirebaseFirestore.instance
              //           .collection('chat_rooms')
              //           .where('people_array', whereIn: [
              //         [userMap['id'], friend.email],
              //         [friend.email, userMap['id']]
              //       ]).get();
              //       String _id = "";
              //       if (data.docs.isNotEmpty) {
              //         _id = data.docs[0].data()['id'].toString();
              //       } else {
              //         DocumentReference docRef = await FirebaseFirestore
              //             .instance
              //             .collection('chat_rooms')
              //             .doc();
              //         await docRef.set({
              //           'id': docRef.id,
              //           'message': [], // John Doe
              //           'people': [
              //             {'name': userMap['usename'], 'id': userMap['id']},
              //             {'name': friend.name, 'id': friend.email}
              //           ], // Stokes and Sons
              //           'people_array': [userMap['id'], friend.email] // 42
              //         });
              //         final data2 = await FirebaseFirestore.instance
              //             .collection('chat_rooms')
              //             .where('people_array', whereIn: [
              //           [userMap['id'], friend.email],
              //           [friend.email, userMap['id']]
              //         ]).get();
              //         _id = data2.docs[0].data()['id'].toString();
              //         // print(_id);
              //       }

              //       Navigator.push(context, MaterialPageRoute(builder: (
              //         context,
              //       ) {
              //         return ChatDetailPage(name: _id);
              //       }));
              //     },
              //     child: new Text('Tin nhan'),
              //   ),
              // ),
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
