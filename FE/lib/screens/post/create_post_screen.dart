import 'package:flutter/material.dart';
import 'package:zalo/apis/post_api.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePostScreen> {
  final _describleController = TextEditingController();
  PostApi _postApi = PostApi();
  late File _imageFile;

  final picker = ImagePicker();

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
      firebaseStorageRef.putFile(_imageFile);
    } on FirebaseException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tạo bài viết"), actions: [
        IconButton(
            icon: const Icon(Icons.arrow_forward),
            tooltip: 'Tạo bài viết',
            onPressed: () {
              _hangleCreatePostPress(context);
            }),
      ]),
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding:
                EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
            child: TextField(
              controller: _describleController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Bạn đang nghĩ gì?',
              ),
            ),
          )),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return new Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              elevation: 16,
                              insetPadding:
                                  EdgeInsets.fromLTRB(50, 200, 50, 200),
                              child: Column(children: [
                                ListTile(
                                    title: Text("Chụp ảnh mới"),
                                    onTap: () {
                                      pickImage().then((value) =>
                                          {uploadImageToFirebase(context)});
                                    }),
                                ListTile(
                                    title: Text("Chọn ảnh từ máy"),
                                    onTap: () {
                                      pickImage2().then((value) =>
                                          {uploadImageToFirebase(context)});
                                    }),
                              ]));
                        });
                  },
                  child: Text('Đăng ảnh')),
              TextButton(onPressed: () {}, child: Text('Đăng video')),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _hangleCreatePostPress(BuildContext context) async {
    final describle = _describleController.text;

    if (describle == '') return;
    bool isOk = await _postApi.createPost(describle);
    if (isOk) {
      Navigator.pop(context, isOk);
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("Thất bại"),
            content: new Text("Có lỗi xảy ra"),
            actions: [TextButton(onPressed: () {}, child: Text("OK"))],
          );
        });
  }
}
