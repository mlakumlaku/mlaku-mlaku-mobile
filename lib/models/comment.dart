import 'package:mlaku_mlaku_mobile/models/place.dart';
import 'package:mlaku_mlaku_mobile/models/souvenir.dart';
import 'package:mlaku_mlaku_mobile/models/comment.dart';

class Comment {
  final int id;
  final String username;
  final String content;
  final int rating;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.username,
    required this.content,
    required this.rating,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      username: json['username'],
      content: json['content'],
      rating: json['rating'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}