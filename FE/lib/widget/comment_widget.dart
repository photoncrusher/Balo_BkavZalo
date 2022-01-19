import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zalo/models/comment.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;

  CommentWidget({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 8.0),
        CircleAvatar(
          backgroundImage: comment.author.avatar != null
              ? NetworkImage(comment.author.avatar ?? '')
              : null,
          child: comment.author.avatar == null
              ? Text(comment.author.name?.substring(0, 1) ?? 'A')
              : null,
          radius: 20.0,
        ),
        SizedBox(width: 8.0),
        Column(
          children: [
            Text(comment.author.name ?? "X",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text(comment.comment),
            SizedBox(height: 8.0),
            Text(DateFormat('dd/MM/yyyy').format(comment.created),
                style: TextStyle(color: Colors.grey[500])),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
