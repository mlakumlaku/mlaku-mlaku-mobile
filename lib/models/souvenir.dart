import 'package:mlaku_mlaku_mobile/models/place.dart';
import 'package:mlaku_mlaku_mobile/models/souvenir.dart';
import 'package:mlaku_mlaku_mobile/models/comment.dart';

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
