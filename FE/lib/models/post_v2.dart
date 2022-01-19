class Post {
  String id;
  String describle;
  DateTime created;
  DateTime modified;
  int like;
  int comment;
  bool isLiked;
  List<MyImage>? images;
  Video? video;
  Author author;
  String state;
  bool isBlocked;
  bool canEdit;
  bool banned;
  bool? canComment;

  Post(
      {required this.id,
      required this.describle,
      required this.created,
      required this.modified,
      required this.like,
      required this.comment,
      required this.isLiked,
      this.images,
      this.video,
      required this.author,
      required this.state,
      required this.isBlocked,
      required this.canEdit,
      required this.banned,
      this.canComment});
  // factory Post.fromJson(Map<String, dynamic> json) {
  //   // DateTime created =
  //   //     DateTime.fromMillisecondsSinceEpoch(int.parse(json['created']));
  //   // DateTime modified =
  //   //     DateTime.fromMillisecondsSinceEpoch(int.parse(json['modified']));
  //   DateTime created = DateTime.parse(json['created']);
  //   DateTime modified = DateTime.parse(json['modified']);
  //   Author author = Author.fromJson(json['author']);

  //   Post post = Post(
  //       id: json['id'],
  //       described: json['describle'],
  //       created: created,
  //       modified: modified,
  //       like: int.parse(json['like'] ?? "0"),
  //       comment: int.parse(json['comment'] ?? "0"),
  //       isLiked: json['is_liked'] == '1',
  //       author: author,
  //       state: json['state'] ?? "",
  //       isBlocked: json['is_blocked'] == '1',
  //       canEdit: json['can_edit'] == '1',
  //       canComment: true,
  //       banned: json['banned'] == '1');

  //   if (json['image'] != null) {
  //     List<MyImage> images = [];
  //     json['image']
  //         .forEach((imageMap) => images.add(MyImage.fromJson(imageMap)));
  //     post.images = images;
  //   } else if (json['video'] != null) {
  //     post.video = Video.fromJson(json['video']);
  //   }

  //   return post;
  // }
  factory Post.fromJson(Map<String, dynamic> json) {
    DateTime created = DateTime.parse(json['created']);
    DateTime modified = DateTime.parse(json['modified']);
    Author author = Author.fromJson(json['author']);
    Post post = Post(
        id: json['id'][0],
        describle: json['describle'],
        created: created,
        modified: modified,
        like: 0,
        comment: json['comment'] ?? 0,
        isLiked: json['is_liked'] == 'true',
        author: author,
        state: json['state'] ?? "",
        isBlocked: json['is_blocked'] == 'true',
        canEdit: json['can_edit'][0] == 'true',
        canComment: json['can_comment'] == 'True',
        banned: json['banned'] == '1');

    // if (json['image'] != null) {
    //   List<MyImage> images = [];
    //   json['image']
    //       .forEach((imageMap) => images.add(MyImage.fromJson(imageMap)));
    //   post.images = images;
    // } else if (json['video'] != null) {
    //   post.video = Video.fromJson(json['video']);
    // }

    return post;
  }
}

class MyImage {
  String id;
  String url;

  MyImage({required this.id, required this.url});

  factory MyImage.fromJson(Map<String, dynamic> json) {
    return MyImage(
      id: json['id'],
      url: json['url'],
    );
  }
}

class Video {
  String url;
  String? thump;
  Video({required this.url, this.thump});
  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      url: json['url'],
      thump: json['thump'],
    );
  }
}

class Author {
  String id;
  String? name;
  String? avatar;

  Author({required this.id, this.name, this.avatar});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      name: json['name'] ?? 'Anonymous',
      avatar: json['avatar'],
    );
  }
}

class ListPost {
  List<Post> posts;
  int newItems;
  String lastId;

  ListPost({required this.posts, required this.newItems, required this.lastId});

  // factory ListPost.fromJson(Map<String, dynamic> json) {
  //   List<Post> posts = [];
  //   json['posts'].forEach((postMap) => posts.add(Post.fromJson(postMap)));
  //   return ListPost(
  //       posts: posts,
  //       newItems: int.parse(json['new_items']),
  //       lastId: json['last_id']);
  // }
  factory ListPost.fromJson(List<dynamic> data) {
    List<Post> posts = [];
    data.forEach((postMap) => posts.add(Post.fromJson(postMap)));
    return ListPost(
        posts: posts, newItems: 0, lastId: posts[posts.length - 1].id);
  }
}
