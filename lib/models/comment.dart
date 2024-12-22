import 'dart:convert';

List<Comment> productFromJson(String str) => List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));
String productToJson(List<Comment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": username,
    "content": content,
    "rating": rating,
    "createdAt": createdAt,
  };
}