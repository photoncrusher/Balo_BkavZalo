import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zalo/apis/post_api.dart';
import 'package:zalo/models/comment.dart';
import 'package:zalo/models/post_v2.dart';
import 'package:zalo/utils/storeService.dart';
import 'package:zalo/widget/comment_widget.dart';
import 'package:zalo/subscene/frienddetails/friend_details_page.dart';
import 'package:zalo/models/friend.dart';

enum PostRole { owner, viewer }
const COUNT = 20;

class PostWidget extends StatefulWidget {
  final void Function(String type, Map<String, dynamic>) callBack;
  final BuildContext parentContext;
  final Post post;

  PostWidget(
      {required this.post,
      required this.callBack,
      required this.parentContext});
// void _navigateToFriendDetails(Friend friend, Object avatarTag) {

//   }
  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final PostApi _postApi = PostApi();
  final StoreService _storeService = StoreService();
  List<Comment> comments = [];
  bool _loading = false;
  bool _loadedComment = false;
  bool _allCommentLoaded = false;

  final commentController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Friend fr_temp = new Friend(
      avatar: widget.post.author.avatar ?? '',
      name: widget.post.author.name ?? 'Anonymous',
      email: '',
      location: 'Ha noi',
    );
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => {
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (c) {
                        return new FriendDetailsPage(fr_temp, avatarTag: '');
                      },
                    ),
                  )
                },
                child: CircleAvatar(
                  backgroundImage: widget.post.author.avatar != null
                      ? NetworkImage(widget.post.author.avatar ?? '')
                      : null,
                  child: widget.post.author.avatar == null
                      ? Text(widget.post.author.name?.substring(0, 1) ?? 'A')
                      : null,
                  radius: 20.0,
                ),
              ),
              SizedBox(width: 7.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.post.author.name ?? 'anonymous',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0)),
                  SizedBox(height: 5.0),
                  Text(DateFormat('dd/MM/yyyy').format(widget.post.created))
                ],
              ),
              Spacer(),
              buildMenu(widget.post.canEdit ? PostRole.owner : PostRole.viewer,
                  widget.post),
            ],
          ),
          SizedBox(height: 20.0),
          Align(
            child: Text(
              widget.post.describle,
              style: TextStyle(fontSize: 15.0),
            ),
            alignment: Alignment.centerLeft,
          ),
          SizedBox(height: 10.0),
          Divider(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: handleLikePressed,
                    icon: Icon(Icons.thumb_up,
                        size: 20.0,
                        color:
                            widget.post.isLiked ? Colors.blue : Colors.black),
                  ),
                  SizedBox(width: 5.0),
                  Text(' ${widget.post.like}'),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                      onPressed: () => {_showCommentWidget(context)},
                      icon: Icon(Icons.comment, size: 20.0)),
                  SizedBox(width: 5.0),
                  Text('${widget.post.comment}'),
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
        context: widget.parentContext,
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

  void handleLikePressed() async {
    final post = widget.post;
    try {
      await _postApi.likePost({"id": post.id});
      setState(() {
        post.isLiked = !post.isLiked;
        post.like = post.isLiked ? post.like + 1 : post.like - 1;
      });
    } catch (e) {
      print(e);
    }
  }

  void setLoading(bool state) {
    setState(() {
      _loading = state;
    });
  }

  void handleDeletePost() async {
    await _postApi.deletePost(widget.post.id);
    widget.callBack('DELETE_POST', {'postId': widget.post.id});
  }

  void handleHidePost() {
    widget.callBack('HIDE_POST', {'postId': widget.post.id});
  }

  void _loadComments(void Function(void Function()) callback) async {
    if (!_loadedComment) {
      _loadedComment = true;
      String token = await _storeService.getToken() ?? "";
      callback(() {
        _loading = true;
      });
      try {
        List<Comment> data = await _postApi.getListComment({
          "token": token,
          "id": widget.post.id,
          "index": "${comments.length}",
          "count": "${COUNT}",
        });
        callback(() {
          comments.addAll(data);
          _allCommentLoaded = data.length < COUNT;
        });
      } catch (err) {
        print(err);
      } finally {
        callback(() {
          _loading = false;
        });
      }
    }
  }

  void handleCreateCommentPressed() async {
    final commentTxt = commentController.text;
    if (commentTxt.isEmpty) return;
    try {
      Comment comment = await _postApi.createComment({
        "id": widget.post.id,
        "comment": commentTxt,
        "index": "${comments.length}",
        "count": "${COUNT}",
      });
      commentController.text = "";
      if (_allCommentLoaded) {
        setState(() {
          // comments.add(comment);
          comments.insert(0, comment);
        });
      }
    } catch (err) {
      print(err);
    }
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

  void _showCommentWidget(context) {
    // _loadComments();
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(builder: (context, setModalState) {
            _loadComments(setModalState);
            return Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                height: MediaQuery.of(context).size.height * .60,
                child: Column(
                  children: <Widget>[
                    Text(
                      "Bình luận",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Divider(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () => {},
                              icon: Icon(Icons.thumb_up,
                                  size: 20.0,
                                  color: widget.post.isLiked
                                      ? Colors.blue
                                      : Colors.black),
                            ),
                            SizedBox(width: 5.0),
                            Text(' ${widget.post.like}'),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                                onPressed: () => {_showCommentWidget(context)},
                                icon: Icon(Icons.comment, size: 20.0)),
                            SizedBox(width: 5.0),
                            Text('${widget.post.comment}'),
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
                    ),
                    Divider(height: 10.0),
                    Expanded(
                        child: ScrollConfiguration(
                      child: (comments.length == 0 &&
                              _allCommentLoaded &&
                              !_loading)
                          ? Text(
                              "Chưa có bình luận nào",
                              textAlign: TextAlign.center,
                            )
                          : ListView.separated(
                              itemBuilder: (context, index) {
                                if (index == comments.length) {
                                  if (_loading) {
                                    return Container(
                                      child: CircularProgressIndicator(),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.only(
                                          top: 4.0, bottom: 4.0),
                                    );
                                  }
                                  return Text("");
                                }
                                return CommentWidget(comment: comments[index]);
                              },
                              itemCount: comments.length + 1,
                              shrinkWrap: true,
                              separatorBuilder: (context, index) => Divider(
                                indent: 16,
                                endIndent: 16,
                              ),
                            ),
                      behavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        },
                      ),
                    )),
                    // Spacer(),
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
                                controller: commentController,
                                decoration: InputDecoration(
                                    hintText: "Nhập bình luận",
                                    hintStyle: TextStyle(color: Colors.black54),
                                    border: InputBorder.none),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            FloatingActionButton(
                              onPressed: () async {
                                final commentTxt = commentController.text;
                                if (commentTxt.isEmpty) return;

                                try {
                                  Comment comment =
                                      await _postApi.createComment({
                                    "id": widget.post.id,
                                    "comment": commentTxt,
                                    "index": "${comments.length}",
                                    "count": "${COUNT}",
                                  });
                                  commentController.text = "";
                                  if (_allCommentLoaded) {
                                    setModalState(() {
                                      comments.add(comment);
                                    });
                                  }
                                } catch (err) {
                                  print(err);
                                }
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
                ));
          });
        });
  }
}
