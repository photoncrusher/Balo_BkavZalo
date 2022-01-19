import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zalo/screens/chatDetail.dart';

class _AZItem extends ISuspensionBean {
  final String title;
  final String tag;
  _AZItem({
    required this.title,
    required this.tag,
  });
  @override
  String getSuspensionTag() => tag;
}

class AlphabetScrollPage extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String> onClickedItem;

  const AlphabetScrollPage({
    Key? key,
    required this.items,
    required this.onClickedItem,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AlphabetScrollPageState();
}

class _AlphabetScrollPageState extends State<AlphabetScrollPage> {
  List<_AZItem> items = [];
  @override
  void initState() {
    super.initState();
    initList(widget.items);
  }

  void initList(List<String> items) {
    this.items = items
        .map((item) => _AZItem(title: item, tag: item[0].toUpperCase()))
        .toList();
    SuspensionUtil.sortListBySuspensionTag(this.items);
    SuspensionUtil.setShowSuspensionStatus(this.items);
  }

  @override
  Widget build(BuildContext context) => AzListView(
        padding: EdgeInsets.all(16),
        data: items,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildListItem(item);
        },
        indexHintBuilder: (context, hint) => Container(
          alignment: Alignment.center,
          width: 60,
          height: 60,
          child: Text(
            hint,
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
        indexBarMargin: EdgeInsets.all(10),
        indexBarOptions: IndexBarOptions(
          needRebuild: true,
          selectTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          selectItemDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          indexHintAlignment: Alignment.centerRight,
          indexHintOffset: Offset(-20, 0),
        ),
      );

  Widget _buildListItem(_AZItem item) {
    final tag = item.getSuspensionTag();
    final offstage = !item.isShowSuspension;
    return Column(
      children: <Widget>[
        Offstage(offstage: offstage, child: buildHeader(tag)),
        Container(
          margin: EdgeInsets.only(right: 16),
          child: ListTile(
            title: Text(item.title),
            // onTap: () =>Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatDetailPage())),
          ),
        )
      ],
    );
  }

  Widget buildHeader(String tag) => Container(
      height: 40,
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.only(left: 16),
      alignment: Alignment.centerLeft,
      child: Text(
        '$tag',
        softWrap: false,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ));
}
