// import 'place.dart';

// class Collection {
//   final int id;
//   final String name;
//   final String createdAt;
//   final int userId;
//   final List<Place> places; // Add places list

//   Collection({
//     required this.id,
//     required this.name,
//     required this.createdAt,
//     required this.userId,
//     required this.places,
//   });

//   /// Factory constructor to parse JSON into a Collection object
//   factory Collection.fromJson(Map<String, dynamic> json) {
//     final fields = json['fields'] as Map<String, dynamic>;
//     return Collection(
//       id: json['pk'] ?? 0, // Map `pk` to `id`
//       name: fields['name'] ?? 'Unknown', // Extract `name` from `fields`
//       createdAt: fields['created_at'] ?? '', // Extract `created_at` from `fields`
//       userId: fields['user'] ?? 0, // Extract `user` from `fields`
//       places: (fields['places'] as List<dynamic>?) // Parse nested places list
//               ?.map((placeJson) => Place.fromJson(placeJson))
//               .toList() ??
//           [], // Default to empty list if null
//     );
//   }

//   // /// Convert Collection object to JSON
//   // Map<String, dynamic> toJson() {
//   //   return {
//   //     'pk': id, // Convert `id` to `pk`
//   //     'fields': {
//   //       'name': name,
//   //       'created_at': createdAt,
//   //       'user': userId,
//   //       'places': places.map((place) => place.toJson()).toList(), // Include places
//   //     },
//   //   };
//   // }
// }

// class CollectionItem {
//   final int collectionId;
//   final int placeId;

//   CollectionItem({
//     required this.collectionId,
//     required this.placeId,
//   });

//   /// Factory constructor to parse JSON into a CollectionItem object
//   factory CollectionItem.fromJson(Map<String, dynamic> json) {
//     return CollectionItem(
//       collectionId: json['collection'] ?? 0, // Extract `collection` ID
//       placeId: json['place'] ?? 0, // Extract `place` ID
//     );
//   }

//   /// Convert CollectionItem object to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'collection': collectionId,
//       'place': placeId,
//     };
//   }
// }






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
        'places': places.map((place) => place.id).toList(),
      },
    };
  }

//   String? getCollectionImageUrl() {
//   for (Place place in places) {
//     if (place.imageUrl != null && place.imageUrl!.isNotEmpty) {
//       return place.imageUrl; // Kembalikan URL gambar dari tempat pertama yang memiliki gambar
//     }
//   }
//   return null; // Tidak ada gambar, kembalikan null
// }

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
