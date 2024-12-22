import 'package:mlaku_mlaku_mobile/models/souvenir.dart';
import 'package:mlaku_mlaku_mobile/models/comment.dart';

class Place {
  final int id;
  final String name;
  final String description;
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
}