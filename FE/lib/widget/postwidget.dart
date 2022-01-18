import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zalo/apis/post_api.dart';
import 'package:zalo/models/post_v2.dart';

enum PostRole { owner, viewer }

class PostWidget extends StatelessWidget {
  final Post post;
  final void Function(String type, Map<String, dynamic>) callBack;
  final BuildContext parentContext;

  final PostApi _postApi = PostApi();

  PostWidget(
      {required this.post,
      required this.callBack,
      required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: post.author.avatar != null
                    ? NetworkImage(post.author.avatar ?? '')
                    : null,
                child: post.author.avatar == null
                    ? Text(post.author.name?.substring(0, 1) ?? 'A')
                    : null,
                radius: 20.0,
              ),
              SizedBox(width: 7.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(post.author.name ?? 'anonymous',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0)),
                  SizedBox(height: 5.0),
                  Text(DateFormat('dd/MM/yyyy').format(post.created))
                ],
              ),
              Spacer(),
              buildMenu(post.canEdit ? PostRole.owner : PostRole.viewer, post),
            ],
          ),
          SizedBox(height: 20.0),
          Align(
            child: Text(
              post.describle,
              style: TextStyle(fontSize: 15.0),
            ),
            alignment: Alignment.centerLeft,
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.thumb_up, size: 15.0),
                  Text(' ${post.like}'),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('${post.comment} comments  •  '),
                  // Text('${post.shares} shares'),
                ],
              ),
            ],
          ),
          Divider(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.thumb_up,
                      size: 20.0,
                      color: post.isLiked ? Colors.blue : Colors.black),
                  SizedBox(width: 5.0),
                  Text('Like', style: TextStyle(fontSize: 14.0)),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.comment, size: 20.0),
                  SizedBox(width: 5.0),
                  Text('Comment', style: TextStyle(fontSize: 14.0)),
                ],
              ),
              // Row(
              //   children: <Widget>[
              //     Icon(Icons.share, size: 20.0),
              //     SizedBox(width: 5.0),
              //     Text('Share', style: TextStyle(fontSize: 14.0)),
              //   ],
              // ),
            ],
          )
        ],
      ),
    );
  }

  List<PopupMenuItem<int>> getMenu(
      BuildContext context, PostRole postRole, String name) {
    if (postRole == PostRole.owner) {
      return [
        const PopupMenuItem<int>(
          value: 0,
          child: Text('Thiết lập quyền xem'),
        ),
        const PopupMenuItem<int>(
          value: 1,
          child: Text('Chỉnh sửa bài đăng'),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Text('Xóa bài đăng'),
        )
      ];
    }
    return [
      // const PopupMenuItem<int>(
      //   value: 3,
      //   child: Text('Xoá hoạt động này'),
      // ),
      PopupMenuItem<int>(
        value: 4,
        child: Text('Ẩn nhật ký của $name'),
      ),
      const PopupMenuItem<int>(
        value: 5,
        child: Text('Báo xấu'),
      ),
    ];
  }

  void handleItemClick(int value) {
    switch (value) {
      case 0: // thiết lập quyền xem
        print('change view role');
        break;
      case 1: // chỉnh sửa bài đăng
        print('edit post');
        break;
      case 2: // xóa bài viết
        print('delete post');
        handleOwnerDeletePost();
        break;
      // case 3: // ??
      //   print('delete post');
      //   break;
      case 4: // ẩn nhật ký
        print('hide post');
        handleHidePost();
        break;
      case 5: // báo cáo xấu
        print('report post');
        break;
    }
  }

  void handleOwnerDeletePost() async {
    showDialog(
        context: parentContext,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("Xác nhận"),
            content: new Text("Bạn muỗn xóa bài đăng"),
            actions: [
              TextButton(
                  onPressed: () {
                    handleDeletePost();
                    Navigator.of(context).pop();
                  },
                  child: Text("Đồng ý")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Hủy"))
            ],
          );
        });
  }

  void handleDeletePost() async {
    await _postApi.deletePost(post.id);
    callBack('DELETE_POST', {'postId': post.id});
  }

  void handleHidePost() {
    callBack('HIDE_POST', {'postId': post.id});
  }

  Widget buildMenu(PostRole postRole, Post post) {
    return PopupMenuButton<int>(
      onSelected: handleItemClick,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        ...getMenu(context, postRole, post.author.name ?? 'Anonymous')
      ],
      icon: const Icon(Icons.more_horiz),
      tooltip: "More actions",
    );
  }
}
