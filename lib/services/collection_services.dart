import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';
import '../models/collections.dart';
import '../models/place.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CollectionService {
  final String baseUrl = "http://127.0.0.1:8000";

  Future<List<Collection>> fetchCollections(CookieRequest request) async {
    final response = await request.get('$baseUrl/placeCollection/json/');
    print('Fetching collections from: $baseUrl/placeCollection/json/');
    print('Response received: $response');
    if (response.isNotEmpty && response is List) {
      return response.map((json) => Collection.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch collections');
    }
  }

  Future<void> createCollection(CookieRequest request, String name) async {
    try {
      print('ATTEMPTING to create collection with name: $name'); // Debug print

      final response = await request.post(
        '$baseUrl/placeCollection/create_collection_json/',
        {
          'name': name,
        },
      );

      print('Response received: $response'); // Debug print

      if (response['success'] == true) {
        print('Collection created: ${response['collection']}');
        // Handle successful creation
      } else {
        print('Failed to create collection: ${response['error']}');
        throw Exception(response['error'] ?? 'Unknown error');
      }
    } catch (e) {
      print('Error creating collection: $e');
      rethrow;
    }
  }

  Future<void> deleteCollection(CookieRequest request, int collectionId) async {
    try {
      final response = await request.post(
          '$baseUrl/placeCollection/delete_flut/$collectionId/', // Make sure this matches your Django URL pattern
          json.encode(
            {},
          ));

      if (response['success'] == true) {
        print("Collection deleted successfully");
      } else {
        throw Exception(response['error'] ?? 'Failed to delete collection');
      }
    } catch (e) {
      print('Error deleting collection: $e');
      rethrow;
    }
  }

  Future<String> getCsrfToken() async {
    final response = await http.get(
        Uri.parse('http://localhost:8000/placeCollection/get-csrf-token/'));
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['csrfToken'];
    } else {
      throw Exception('Failed to load CSRF token');
    }
  }

  
  Future<List<Place>> fetchCollectionPlaces(int collectionId, CookieRequest request) async {
  try {
    print('Fetching places for collection $collectionId');
    final response = await request.get('$baseUrl/placeCollection/$collectionId/places/json/');
    print('Raw response: $response');

    // Parse the Django serialized format
    List<dynamic> jsonList = response is String ? json.decode(response) : response;
    
    return jsonList.map((placeJson) {
      Map<String, dynamic> fields = Map<String, dynamic>.from(placeJson['fields']);
      // Add the id from pk to fields
      fields['id'] = placeJson['pk'];
      
      // Initialize empty lists for comments and souvenirs if they don't exist
      fields['comments'] = [];  // Initialize empty comments list
      fields['souvenirs'] = []; // Initialize empty souvenirs list
      
      print('Processing fields: $fields'); // Debug print
      
      return Place.fromJson(fields);
    }).toList();
  } catch (e) {
    print('Error in fetchCollectionPlaces: $e');
    throw Exception('Failed to load collection places: $e');
  }
}

  Future<bool> addPlaceToCollections(
    CookieRequest request,
    int placeId,
    List<int> collectionIds,
  ) async {
    try {
      final url = '$baseUrl/places/flutter/$placeId/add_to_collection_flutter/';
      print('Sending request to: $url');

      final response = await request.post(
          url,
          json.encode({
            'collections': collectionIds,
            'X-Requested-With': 'XMLHttpRequest',
          }));

      print('Response received: $response');

      if (response['success'] == true) {
        return true;
      } else {
        throw Exception(response['error'] ?? 'Failed to add to collections');
      }
    } catch (e) {
      print('Error adding place to collections: $e');
      rethrow;
    }
  }
}
