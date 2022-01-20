import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zalo/apis/base_api.dart';
import 'package:zalo/constants/api_path.dart';
import 'package:zalo/models/api_exception.dart';
import 'package:zalo/models/comment.dart';
import 'package:zalo/models/post_v2.dart';

class PostApi {
  PostApi._privateConstructor();

  static final PostApi _instance = PostApi._privateConstructor();

  factory PostApi() {
    return _instance;
  }

  BaseApi _api = BaseApi();

  Future<ListPost> getListPost(
      String token, String? lastId, int index, int count) async {
    final uri = Uri.parse(BASE_URL + '/post/list_post');
    final data = {
      'token': token,
      'last_id': lastId,
      'index': '$index',
      'count': '$count'
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8'
    };
    print('getListPost');
    // print(data);
    final res = await http.post(uri, headers: headers, body: jsonEncode(data));
    final jsonData = jsonDecode(utf8.decode(res.bodyBytes));
    print(jsonData['data'][0]);
    if (res.statusCode >= 400) {
      throw APIException.fromJson(jsonData);
    }
    return ListPost.fromJson(jsonData['data']);
    // if (index >= 20) return ListPost.fromJson(empty_list_post);
    // await Future.delayed(Duration(seconds: 2));
    // return ListPost.fromJson(fake_list_post);
  }

  Future<bool> deletePost(String postId) async {
    print('deletePost');
    final res =
        await _api.request({'post_id': postId}, '/post/delete?id=$postId');
    final jsonData = jsonDecode(res.body);

    if (res.statusCode >= 400) {
      throw APIException.fromJson(jsonData);
    }
    return jsonData['code'] == 1000;
  }

  Future<bool> reportPost(String postId, String token) async {
    return false;
  }

  Future<bool> createPost(String describle) async {
    print("createPost");
    final res = await _api.request({'describle': describle}, '/post/create');

    final jsonData = jsonDecode(res.body);

    if (res.statusCode >= 400) {
      throw APIException.fromJson(jsonData);
    }
    if (jsonData['code'] == 1000) return true;

    return false;
  }

  Future<void> likePost(Map<String, dynamic> data) async {
    print("likePost");
    final res = await _api.request(data, "/post/like");

    final jsonData = jsonDecode(res.body);
    if (res.statusCode >= 400) {
      throw APIException.fromJson(jsonData);
    }
  }

  Future<Comment> createComment(Map<String, dynamic> data) async {
    print("createComment");
    final res = await _api.request(data, "/comment/create");

    final jsonData = jsonDecode(utf8.decode(res.bodyBytes));
    if (res.statusCode >= 400) {
      throw APIException.fromJson(jsonData);
    }
    return Comment.fromJson(jsonData['data']);
  }

  Future<List<Comment>> getListComment(Map<String, dynamic> data) async {
    print("getListComment");
    final res = await _api.request(data, "/comment/list");

    final jsonData = jsonDecode(utf8.decode(res.bodyBytes));

    if (res.statusCode >= 400) {
      throw APIException.fromJson(jsonData);
    }

    List<Comment> comments = [];
    List<dynamic> listCommentJson = jsonData['data'];
    for (final commentJson in listCommentJson) {
      Comment comment = Comment.fromJson(commentJson);
      comments.add(comment);
    }
    return comments;
  }
}
