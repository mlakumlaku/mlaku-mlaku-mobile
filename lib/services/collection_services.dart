import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';
import '../models/collections.dart';
import '../models/place.dart';

class CollectionService {
  final String baseUrl = "http://127.0.0.1:8000";

  Future<List<Collection>> fetchCollections(CookieRequest request) async {
    final response = await request.get('$baseUrl/placeCollection/json/');
    if (response.isNotEmpty && response is List) {
      return response.map((json) => Collection.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch collections');
    }
  }

  Future<void> createCollection(CookieRequest request, String name) async {
    final response = await request.post('$baseUrl/placeCollection/create/', {
      'name': name,
    });

    if (!response['success']) {
      throw Exception('Failed to create collection: ${response['error']}');
    }
  }

  Future<void> deleteCollection(CookieRequest request, int collectionId) async {
    final response = await request.post(
      '$baseUrl/placeCollection/delete/$collectionId/',
      {'_method': 'DELETE'},
    );

    if (!response['success']) {
      throw Exception('Failed to delete collection: ${response['error']}');
    }
  }

  Future<List<Place>> fetchCollectionPlaces(CookieRequest request, int collectionId) async {
    final response = await request.get('$baseUrl/placeCollection/$collectionId/places/json/');

    if (response.isNotEmpty && response is List) {
      return response.map((json) => Place.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch places for collection $collectionId');
    }
  }
}
