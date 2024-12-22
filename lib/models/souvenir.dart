import 'dart:convert';

List<Souvenir> productFromJson(String str) => List<Souvenir>.from(json.decode(str).map((x) => Souvenir.fromJson(x)));
String productToJson(List<Souvenir> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "stock": stock,
  };
}