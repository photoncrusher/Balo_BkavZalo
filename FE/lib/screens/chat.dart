import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:zalo/widget/conversation.dart';
import 'package:zalo/models/chatUserModel.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUsers> chatUsers = [
    ChatUsers(
        name: "Jane Russel",
        messageText: "Awesome Setup",
        imageURL: "images/beluwa.jpg",
        time: "Now"),
    ChatUsers(
        name: "Glady's Murphy",
        messageText: "That's Great",
        imageURL: "images/beluwa.jpg",
        time: "Yesterday"),
    ChatUsers(
        name: "Jorge Henry",
        messageText: "Hey where are you?",
        imageURL: "images/beluwa.jpg",
        time: "31 Mar"),
    ChatUsers(
        name: "Philip Fox",
        messageText: "Busy! Call me in 20 mins",
        imageURL: "images/beluwa.jpg",
        time: "28 Mar"),
    ChatUsers(
        name: "Debra Hawkins",
        messageText: "Thankyou, It's awesome",
        imageURL: "images/beluwa.jpg",
        time: "23 Mar"),
    ChatUsers(
        name: "Jacob Pena",
        messageText: "will update you in evening",
        imageURL: "images/beluwa.jpg",
        time: "17 Mar"),
    ChatUsers(
        name: "Andrey Jones",
        messageText: "Can you please share the file?",
        imageURL: "images/beluwa.jpg",
        time: "24 Feb"),
    ChatUsers(
        name: "John Wick",
        messageText: "How are you?",
        imageURL: "images/beluwa.jpg",
        time: "18 Feb"),
  ];
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // final databases = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('chat_rooms')
      .where('user_id', whereIn: ['0858105968']).snapshots(
          includeMetadataChanges: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            final chat_rooms = snapshot.data!.docs;
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
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Map<String, dynamic> data =
                    chat_rooms[index].data() as Map<String, dynamic>;

                return ConversationList(
                  // name: docs[index]['phonenumber'],
                  id: data['id'],
                  name: data['people'][0]['name'],
                  messageText: chatUsers[index].messageText,
                  imageUrl: chatUsers[index].imageURL,
                  time: chatUsers[index].time,
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
