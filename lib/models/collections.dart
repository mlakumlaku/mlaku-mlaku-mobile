import 'place.dart';

class Collection {
  final int id;
  final String name;
  final String createdAt;
  final int userId;
  final List<Place> places;

  Collection({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.userId,
    required this.places,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    // Handle case where fields might not exist
    final fields = json['fields'] as Map<String, dynamic>? ?? {};
    
    // Handle places data which might come directly in json or in fields
    List<Place> parsePlaces() {
      if (fields.containsKey('places')) {
        final placesList = fields['places'] as List<dynamic>? ?? [];
        return placesList.map((placeJson) => Place.fromJson(placeJson)).toList();
      } else if (json.containsKey('places')) {
        final placesList = json['places'] as List<dynamic>? ?? [];
        return placesList.map((placeJson) => Place.fromJson(placeJson)).toList();
      }
      return [];
    }

    return Collection(
      id: json['pk'] ?? json['id'] ?? 0,  // Try both pk and id
      name: fields['name'] ?? json['name'] ?? 'Unknown',
      createdAt: fields['created_at'] ?? json['created_at'] ?? '',
      userId: fields['user'] ?? json['user'] ?? 0,
      places: parsePlaces(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pk': id,
      'fields': {
        'name': name,
        'created_at': createdAt,
        'user': userId,
        'places': places.map((place) => place.toJson()).toList(),
      },
    };
  }
}

class CollectionItem {
  final int collectionId;
  final int placeId;

  CollectionItem({
    required this.collectionId,
    required this.placeId,
  });

  factory CollectionItem.fromJson(Map<String, dynamic> json) {
    // Add null safety checks
    return CollectionItem(
      collectionId: json['collection'] ?? 0,
      placeId: json['place'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collection': collectionId,
      'place': placeId,
    };
  }
}