// // // To parse this JSON data, do
// // //
// // //     final place = placeFromJson(jsonString);

// // import 'dart:convert';

// // Place placeFromJson(String str) => Place.fromJson(json.decode(str));

// // String placeToJson(Place data) => json.encode(data.toJson());

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
    id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String,
    // Handle null or missing average_rating
    averageRating: json['average_rating'] != null 
        ? (json['average_rating'] is int 
            ? (json['average_rating'] as int).toDouble() 
            : json['average_rating'] as double)
        : 0.0,  // Default to 0.0 if null
    comments: (json['comments'] as List?)?.map((comment) => 
        Comment.fromJson(comment)).toList() ?? [],
    souvenirs: (json['souvenirs'] as List?)?.map((souvenir) => 
        Souvenir.fromJson(souvenir)).toList() ?? [],
  );
}
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      // 'image_url': imageUrl,
    };
  }
}



// // class Comment {
// //     int id;
// //     String username;
// //     String content;
// //     int rating;
// //     DateTime createdAt;

// //     Comment({
// //         required this.id,
// //         required this.username,
// //         required this.content,
// //         required this.rating,
// //         required this.createdAt,
// //     });

// //     factory Comment.fromJson(Map<String, dynamic> json) => Comment(
// //         id: json["id"],
// //         username: json["username"],
// //         content: json["content"],
// //         rating: json["rating"],
// //         createdAt: DateTime.parse(json["created_at"]),
// //     );

// //     Map<String, dynamic> toJson() => {
// //         "id": id,
// //         "username": username,
// //         "content": content,
// //         "rating": rating,
// //         "created_at": createdAt.toIso8601String(),
// //     };
// // }

// // class Souvenir {
// //     int id;
// //     String name;
// //     int price;
// //     int stock;

// //     Souvenir({
// //         required this.id,
// //         required this.name,
// //         required this.price,
// //         required this.stock,
// //     });

// //     factory Souvenir.fromJson(Map<String, dynamic> json) => Souvenir(
// //         id: json["id"],
// //         name: json["name"],
// //         price: json["price"],
// //         stock: json["stock"],
// //     );

// //     Map<String, dynamic> toJson() => {
// //         "id": id,
// //         "name": name,
// //         "price": price,
// //         "stock": stock,
// //     };
// // }


// // models/souvenir.dart
// class Souvenir {
//   final int id;
//   final String name;
//   final double price;
//   final int stock;

//   Souvenir({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.stock,
//   });

//   factory Souvenir.fromJson(Map<String, dynamic> json) {
//     return Souvenir(
//       id: json['id'],
//       name: json['name'],
//       price: json['price'].toDouble(),
//       stock: json['stock'],
//     );
//   }
// }

// // models/comment.dart
// class Comment {
//   final int id;
//   final String username;
//   final String content;
//   final int rating;
//   final DateTime createdAt;

//   Comment({
//     required this.id,
//     required this.username,
//     required this.content,
//     required this.rating,
//     required this.createdAt,
//   });

//   factory Comment.fromJson(Map<String, dynamic> json) {
//     return Comment(
//       id: json['id'],
//       username: json['username'],
//       content: json['content'],
//       rating: json['rating'],
//       createdAt: DateTime.parse(json['created_at']),
//     );
//   }
// }

// // models/place.dart
// class Place {
//   final int id;
//   final String name;
//   final String description;
//   final double averageRating;
//   final List<Comment> comments;
//   final List<Souvenir> souvenirs;

//   Place({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.averageRating,
//     required this.comments,
//     required this.souvenirs,
//   });

//   factory Place.fromJson(Map<String, dynamic> json) {
//     return Place(
//       id: json['id'],
//       name: json['name'],
//       description: json['description'],
//       averageRating: json['average_rating'].toDouble(),
//       comments: (json['comments'] as List)
//           .map((comment) => Comment.fromJson(comment))
//           .toList(),
//       souvenirs: (json['souvenirs'] as List)
//           .map((souvenir) => Souvenir.fromJson(souvenir))
//           .toList(),
//     );
//   }
// }


// models/souvenir.dart
class Souvenir {
  final int id;
  final String name;
  final double price;
  final int stock;

  Souvenir({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
  });

  factory Souvenir.fromJson(Map<String, dynamic> json) {
    return Souvenir(
      id: json['id'],
      name: json['name'],
      price: (json['price'] is int) ? json['price'].toDouble() : json['price'],
      stock: json['stock'],
    );
  }
}

// models/comment.dart
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

