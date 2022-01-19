import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zalo/models/chatMessageModel.dart';

// ignore: must_be_immutable
class ChatDetailPage extends StatefulWidget {
  String name;
  //  SharedPreferences sharedPreferences =getSharedPreferences("MySharedPref",MODE_PRIVATE);

  // String messageText;
  // String imageUrl;
  // String time;
  ChatDetailPage({
    required this.name,
    // required this.messageText,
    // required this.imageUrl,
    // required this.time,
  });

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  // List<ChatMessage> messages = [
  //   ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
  //   ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
  //   ChatMessage(
  //       messageContent: "Hey Kriss, I am doing fine dude. wbu?",
  //       messageType: "sender"),
  //   ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
  //   ChatMessage(
  //       messageContent: "Is there any thing wrong?", messageType: "sender"),
  // ];
  // final Stream<QuerySnapshot> _usersStream = ;
  String _userid = "";
  String _chatInput = "";

  final chatInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    chatInputController.dispose();
    super.dispose();
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
    print(widget.name);
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chat_rooms').where('id',
            whereIn: [widget.name]).snapshots(includeMetadataChanges: true),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          final chat_rooms = snapshot.data!.docs;

          Map<String, dynamic> data =
              chat_rooms[0].data() as Map<String, dynamic>;

          final List<ChatMessage> messages = [];
          // chat_rooms.forEach((k, v) => weightData.add(Weight(k, v)));
          int current_guest = (data['people'][0]['id'] == _userid) ? 1 : 0;

          int current_host = (data['people'][0]['id'] == _userid) ? 0 : 1;
          data['message'].forEach((message) {
            // print(message['content']);
            String msg_type =
                (data['people'][current_host]['id'] == message['user_id'])
                    ? "sender"
                    : "receiver";
            messages.add(ChatMessage(
                messageContent: message['content'], messageType: msg_type));
          });
          // print(data['message'][1]['content']);

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              // backgroundColor: Colors.blue,

              flexibleSpace: SafeArea(
                child: Container(
                  padding: EdgeInsets.only(right: 16),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              data['people'][current_guest]['name'],
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade50),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "",
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Stack(
              children: <Widget>[
                ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                      top: 10, bottom: kFloatingActionButtonMargin + 48),
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index_old) {
                    int index = messages.length - 1 - index_old;
                    // print(messages.length);
                    return Container(
                      padding: EdgeInsets.only(
                          left: 14, right: 14, top: 10, bottom: 10),
                      child: Align(
                        alignment: (messages[index].messageType == "receiver"
                            ? Alignment.topLeft
                            : Alignment.topRight),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (messages[index].messageType == "receiver"
                                ? Colors.grey.shade200
                                : Colors.blue[200]),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Text(
                            messages[index].messageContent,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    height: 60,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            controller: chatInputController,
                            decoration: InputDecoration(
                                hintText: "Tin nhắn",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            _chatInput = chatInputController.text;
                            if (_chatInput != '') {
                              FirebaseFirestore.instance
                                  .collection('chat_rooms')
                                  .doc(data['id'])
                                  .update({
                                'message': FieldValue.arrayUnion([
                                  {
                                    'content': _chatInput,
                                    'user_id': data['people'][current_host]
                                        ['id'],
                                    'created':
                                        Timestamp.fromDate(DateTime.now())
                                  }
                                ])
                              });
                            }
                            ;
                            chatInputController.clear();
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                          backgroundColor: Colors.blue,
                          elevation: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
