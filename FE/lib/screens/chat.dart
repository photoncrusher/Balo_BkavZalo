import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zalo/widget/conversation.dart';
// import 'package:zalo/models/chatUserModel.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String _userid = "";

  @override
  void initState() {
    super.initState();
    loadState();
  }

  Future<Map<String, dynamic>> loadState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonInfo = prefs.getString('login_info') ?? "{'user_id': ''}";
    Map<String, dynamic> userMap = json.decode(jsonInfo);
    setState(() {
      _userid = userMap['id'];
    });
    return userMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chat_rooms')
              .where('people_array', arrayContainsAny: [_userid]).snapshots(
                  includeMetadataChanges: true),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            // final temp = snapshot.data!.docs;
            final chat_rooms = [];
            snapshot.data!.docs.forEach((element) {
              Map<String, dynamic> data =
                  element.data() as Map<String, dynamic>;
              if (data['message'].isNotEmpty) {
                chat_rooms.add(element);
              }
              ;
            });
            // temp
            // snapshot.data!.docs.forEach((result) {
            //   print(result.data());
            // });
            // if (snapshot.hasData) {
            //   print(snapshot.data!.docs[4].data.toString());
            // }
            return ListView.builder(
              itemCount: chat_rooms.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Map<String, dynamic> data =
                    chat_rooms[index].data() as Map<String, dynamic>;

                int current_guest =
                    (data['people'][0]['id'] == _userid) ? 1 : 0;

                // int current_host = (data['people'][0]['id'] == _userid) ? 0 : 1;

                return ConversationList(
                  // name: docs[index]['phonenumber'],
                  id: data['id'],
                  name: data['people'][current_guest]['name'],
                  messageText: data['message'].last['content'] ?? ' ',
                  imageUrl: '',
                  time: DateFormat.yMMMd()
                      .add_jm()
                      .format(data['message'].last['created'].toDate()),
                  isMessageRead: (index == 0 || index == 3) ? true : false,
                );
              },
            );
            // return ListView.builder(
            //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
            //     Map<String, dynamic> data =
            //         document.data()! as Map<String, dynamic>;
            //     return ConversationList(
            //       name: Text(data['phonenumber']).toString(),
            //       messageText: Text(data['username']).toString(),
            //       imageUrl: '/',
            //       time: '12122012',
            //       isMessageRead: false,
            //     );
            //   }).toList(),
            // );
          }),
    ])));
  }
}
