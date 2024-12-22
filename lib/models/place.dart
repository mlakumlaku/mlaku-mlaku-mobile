import 'package:mlaku_mlaku_mobile/models/souvenir.dart';
import 'package:mlaku_mlaku_mobile/models/comment.dart';
import 'dart:convert';

List<Place> productFromJson(String str) => List<Place>.from(json.decode(str).map((x) => Place.fromJson(x)));
String productToJson(List<Place> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Place {
  final int id;
  String name;
  String description;
  final double averageRating;
  final List<Comment> comments;
  final List<Souvenir> souvenirs;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.averageRating,
    required this.comments,
    required this.souvenirs,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      averageRating: (json['average_rating'] is int) 
          ? json['average_rating'].toDouble() 
          : json['average_rating'],
      comments: (json['comments'] as List)
          .map((comment) => Comment.fromJson(comment))
          .toList(),
      souvenirs: (json['souvenirs'] as List)
          .map((souvenir) => Souvenir.fromJson(souvenir))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "averageRating": averageRating,
    "comments": comments,
    "souvenirs": souvenirs,
  };
}