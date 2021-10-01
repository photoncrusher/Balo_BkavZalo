import 'package:flutter/material.dart';

Widget registerForm(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(32),
    child: Column(
      children: <Widget>[
        Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: const TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Tên đầy đủ',
              ),
            )),
      ],
    ),
  );
}

Widget bottomButton(BuildContext context) {
  return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
        onPressed: () {},
        child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
          primary: Colors.blue, // <-- Button color
          onPrimary: Colors.red, // <-- Splash color
        ),
      ));
}

class RegisterScene extends StatelessWidget {
  const RegisterScene({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text("Đăng ký"),
            centerTitle: true,
          ),
          body: Center(
            child: Stack(children: [
              registerForm(context),
              bottomButton(context),
            ]),
          )),
    );
  }
}
