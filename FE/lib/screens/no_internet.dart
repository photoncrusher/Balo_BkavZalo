import 'package:flutter/material.dart';
import 'package:zalo/constants/image_path.dart';

class NoInternet extends StatelessWidget {
  final void Function(BuildContext context) callback;

  NoInternet(@required this.callback);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          TextButton(
              onPressed: () => callback(context), child: Text("Go back")),
          Spacer(
            flex: 2,
          ),
          Image(image: AssetImage(Images.LOGO_ZALO), width: 108, height: 36),
          Spacer(flex: 2),
          Image(image: AssetImage(Images.NO_INTERNET), width: 36, height: 36),
          Container(
              margin: const EdgeInsets.only(top: 26, bottom: 10),
              child: Text(
                "Không có kết nối internet.",
                style: TextStyle(color: Colors.red),
              )),
          Text("Vui lòng kiểm tra lại đường truyền.",
              style: TextStyle(color: Colors.grey)),
          Text("Công việc sẽ tiếp tục khi có kết nối internet.",
              style: TextStyle(color: Colors.grey)),
          Spacer(
            flex: 2,
          )
        ],
      )),
    );
  }
}
