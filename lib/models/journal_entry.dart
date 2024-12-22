import 'dart:convert';

List<JournalEntry> journalEntryFromJson(String str) => 
    List<JournalEntry>.from(json.decode(str).map((x) => JournalEntry.fromJson(x)));

String journalEntryToJson(List<JournalEntry> data) => 
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JournalEntry {
    String model;
    int pk;
    JournalFields fields;

    JournalEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
        model: json["model"],
        pk: json["pk"],
        fields: JournalFields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class JournalFields {
    int author;
    String authorUsername;  // Changed from username
    String title;
    String content;
    DateTime createdAt;
    DateTime updatedAt;
    String image;
    int? souvenir;
    String? placeName;
    List<int> likes;
    String? souvenirName;
    String? souvenirPrice;
    double? price;
    int likesCount;

    JournalFields({
        required this.author,
        required this.authorUsername,  // Changed from username
        required this.title,
        required this.content,
        required this.createdAt,
        required this.updatedAt,
        required this.image,
        this.souvenir,
        this.placeName,
        required this.likes,
        this.souvenirName,
        this.souvenirPrice,
        this.price,
        required this.likesCount,
    });

    factory JournalFields.fromJson(Map<String, dynamic> json) => JournalFields(
        author: json["author"],
        authorUsername: json["author_username"] ?? "Anonymous",  // Changed from username
        title: json["title"],
        content: json["content"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        image: json["image"] ?? "",
        souvenir: json["souvenir"],
        placeName: json["place_name"],
        likes: List<int>.from(json["likes"] ?? []),
        souvenirName: json["souvenir_name"],
        souvenirPrice: json["souvenir_price"],
        price: json["price"]?.toDouble(),
        likesCount: json["likes_count"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "author": author,
        "author_username": authorUsername,  // Changed from username
        "title": title,
        "content": content,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "image": image,
        "souvenir": souvenir,
        "place_name": placeName,
        "likes": List<dynamic>.from(likes.map((x) => x)),
        "souvenir_name": souvenirName,
        "souvenir_price": souvenirPrice,
        "price": price,
        "likes_count": likesCount,
    };
}
