import 'package:flutter/material.dart';
import 'package:zalo/constants/image_path.dart';

const TextStyle headingStyle = TextStyle(fontSize: 36, color: Colors.blue);
const TextStyle bigwordStyle = TextStyle(fontSize: 22);
const TextStyle smallwordStyle = TextStyle(fontSize: 20);

final ButtonStyle style = ElevatedButton.styleFrom(
    primary: Colors.blue,
    textStyle: const TextStyle(fontSize: 25),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    minimumSize: const Size(350, 70),
    maximumSize: const Size(400, 70));

final ButtonStyle style2 = ElevatedButton.styleFrom(
    primary: Colors.grey[300],
    textStyle: const TextStyle(fontSize: 25, color: Colors.black),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    minimumSize: const Size(350, 70),
    maximumSize: const Size(400, 70));

Widget loginSelection(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(32),
    child: Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 16),
          child: ElevatedButton(
            style: style,
            onPressed: () {
              Navigator.pushNamed(context, "/login");
            },
            child: const Text('Đăng nhập'),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 16),
          child: ElevatedButton(
            style: style2,
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const RegisterForm()),
              // );
              Navigator.pushNamed(context, "/register");
            },
            // onPressed: null,
            child: const Text(
              'Đăng ký',
              style: TextStyle(fontSize: 25, color: Colors.black),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget textSection(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(32),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 14),
          child: const Text(
            "Chat nhóm tiện ích",
            style: bigwordStyle,
          ),
        ),
        // Container(
        //   padding: const EdgeInsets.only(bottom: 14),
        //   child: const Text(
        //     "Hãy cũng nhau trao đổi, giữ liên lạc với gia đình, bạn bè, đồng nghiệp",
        //     style: smallwordStyle,
        //   ),
        // )
      ],
    ),
  );
}

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);
  static const String _title = 'Zalo';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Center(
      //       child: Text(
      //     _title,
      //     style: headingStyle,
      //   )),
      //   backgroundColor: Colors.white,
      // ),
      body: Center(
        child: Column(children: [
          Image.asset(
            // 600 480
            Images.INTRO,
            width: 440,
            height: 352,
            fit: BoxFit.cover,
          ),
          // textSection(context),
          Spacer(flex: 1),
          loginSelection(context),
          const Text("Tiếng Việt"),
          Spacer(flex: 2),
        ]),
      ),
    );
  }
}
