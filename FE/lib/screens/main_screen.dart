import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zalo/screens/chat.dart';
import 'package:zalo/screens/post/postPage.dart';
import 'package:zalo/screens/profilePage.dart';
import 'package:zalo/screens/contact.dart';
import 'package:zalo/screens/friend_recommend.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  String _userid = "";

  // Future<Map<String, dynamic>> loadState() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String jsonInfo = prefs.getString('login_info') ?? "{'user_id': ''}";
  //   Map<String, dynamic> userMap = json.decode(jsonInfo);
  //   setState(() {
  //     _userid = userMap['id'];
  //   });
  //   return userMap;
  // }
  // final futureBuilder =

  // final futureBuilder = Null;
  @override
  void initState() {
    super.initState();

    // loadState();
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    ChatPage(),
    // FutureBuilder<DocumentSnapshot>(
    //   future: FirebaseFirestore.instance
    //       .collection('users')
    //       .doc("0332152199")
    //       .get(),
    //   builder:
    //       (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //     if (snapshot.hasError) {
    //       return Text("Something went wrong");
    //     }

    //     if (snapshot.hasData && !snapshot.data!.exists) {
    //       return Text("Document does not exist");
    //     }

    //     if (snapshot.connectionState == ConnectionState.done) {
    //       Map<String, dynamic> data =
    //           snapshot.data!.data() as Map<String, dynamic>;
    //       final name = data['friend_list'].map((item) => item["name"]),
    //           phone = data['friend_list'].map((item) => item["phone"]);

    //       // Map<String, dynamic> data_2 =
    //       //     data['friend_list'] as Map<String, dynamic>;
    //       print(name);
    //       return Scaffold(
    //           body: AlphabetScrollPage(
    //         onClickedItem: (item) {},
    //         items: data['friend_list'],
    //       )); // return Text("Full Name: ${data['full_name']} ${data['last_name']}");
    //     }

    //     return Text("loading");
    //   },
    // ),
    Scaffold(
      body: FriendsListPage(),
    ),
    PostPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var document =
    //     FirebaseFirestore.instance.collection('users').doc(_userid).get();
    // print(document.docs!.data());
// document.get() => then(function(document) {
//     print(document("name"));
// });
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          title: const Text("Tìm bạn bè, tin nhắn"),
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
          centerTitle: false),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Tin nhắn',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.contact_phone),
          //   label: 'Danh bạ',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Khám phá',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_clock),
            label: 'Nhật ký',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Cá nhân',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[600],
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyStatefulWidget();
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("search screen"),
      ),
      body: Center(
        child: Text("Search Screen"),
      ),
    );
  }
}
