// To parse this JSON data, do
//
//     final place = placeFromJson(jsonString);

import 'dart:convert';

Place placeFromJson(String str) => Place.fromJson(json.decode(str));

String placeToJson(Place data) => json.encode(data.toJson());

class Place {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;

  Place({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    // Handle case where fields might be nested
    final fields = json['fields'] as Map<String, dynamic>? ?? json;
    
    return Place(
      id: json['pk'] ?? json['id'] ?? 0,  // Try both pk and id
      name: fields['name'] ?? '',
      description: fields['description'] ?? '',
      imageUrl: fields['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
    };
  }
}

class Comment {
    int id;
    String username;
    String content;
    int rating;
    DateTime createdAt;

    Comment({
        required this.id,
        required this.username,
        required this.content,
        required this.rating,
        required this.createdAt,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        username: json["username"],
        content: json["content"],
        rating: json["rating"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "content": content,
        "rating": rating,
        "created_at": createdAt.toIso8601String(),
    };
}

class Souvenir {
    int id;
    String name;
    int price;
    int stock;

    Souvenir({
        required this.id,
        required this.name,
        required this.price,
        required this.stock,
    });

    factory Souvenir.fromJson(Map<String, dynamic> json) => Souvenir(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        stock: json["stock"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "stock": stock,
    };
}
