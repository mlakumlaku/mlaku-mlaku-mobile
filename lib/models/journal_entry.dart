// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Welcome {
    String model;
    int pk;
    Fields fields;

    Welcome({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int author;
    String title;
    String content;
    DateTime createdAt;
    DateTime updatedAt;
    String image;
    int? souvenir;
    String? placeName;
    List<int> likes;

    Fields({
        required this.author,
        required this.title,
        required this.content,
        required this.createdAt,
        required this.updatedAt,
        required this.image,
        required this.souvenir,
        required this.placeName,
        required this.likes,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        author: json["author"],
        title: json["title"],
        content: json["content"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        image: json["image"],
        souvenir: json["souvenir"],
        placeName: json["place_name"],
        likes: List<int>.from(json["likes"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "author": author,
        "title": title,
        "content": content,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "image": image,
        "souvenir": souvenir,
        "place_name": placeName,
        "likes": List<dynamic>.from(likes.map((x) => x)),
    };
}
