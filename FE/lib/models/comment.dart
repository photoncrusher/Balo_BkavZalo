// class Comment {
//   String id;
//   String comment;
//   DateTime created;
//   DateTime modified;
//   String post_id;
//   Author author;

//   Comment(
//       {required this.id,
//       required this.post_id,
//       required this.created,
//       required this.modified,
//       required this.comment,
//       required this.author});

//   factory Comment.fromJson(Map<String, dynamic> json) {
//     DateTime created = DateTime.parse(json['created']);
//     DateTime modified = DateTime.parse(json['modified']);
//     Author author = Author.fromJson(json['poster']);
//     Comment comment = Comment(
//         id: json['id'][0],
//         post_id: json['post_id'],
//         created: created,
//         modified: modified,
//         author: author,
//         comment: json['comment']);

//     return comment;
//   }
// }

// class Author {
//   String id;
//   String? name;
//   String? avatar;

//   Author({required this.id, this.name, this.avatar});

//   factory Author.fromJson(Map<String, dynamic> json) {
//     return Author(
//       id: json['id'],
//       name: json['name'] ?? 'Anonymous',
//       avatar: json['avatar'],
//     );
//   }
// }

// // class ListComment {
// //   List<Comment> comments;
// //   int? newItems;
// //   String? lastId;

// //   List({required this.comments, required this.newItems, required this.lastId});

// //   factory ListComment.fromJson(List<dynamic> data) {
// //     List<Comment> comments = [];
// //     data.forEach((commentMap) => comments.add(Comment.fromJson(commentMap)));
// //     return ListComment(
// //         comments: comments,
// //         newItems: 0,
// //         lastId: comments[comments.length - 1].id);
// //   }
// // }
