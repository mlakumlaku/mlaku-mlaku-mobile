import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/place.dart';

class PlaceService {
  final CookieRequest request;
  static const String baseUrl = 'http://127.0.0.1:8000/places';

  PlaceService(this.request);

  Future<Place> getPlaceDetails(int placeId) async {
    print("Fetching place details for ID: $placeId");
    final response = await request.get('$baseUrl/$placeId/json/');
    print("Place details response: $response");
    return Place.fromJson(response);
  }

  Future<void> addComment(int placeId, String content, int rating) async {
    print("Adding comment for place ID: $placeId");
    print("Comment data: content=$content, rating=$rating");
    
    try {
      final response = await request.post(
        '$baseUrl/flutter/add_comment/$placeId/',
        {
          'comment': content,
          'rating': rating.toString(),
        },
      );
      
      print("Add comment response: $response");
      
      if (response['status'] == 'error') {
        throw Exception(response['message']);
      }
    } catch (e) {
      print("Error adding comment: $e");
      throw Exception('Failed to add comment: $e');
    }
  }

  Future<void> editComment(int commentId, String content, int rating) async {
    print("Editing comment ID: $commentId");
    print("Current login status: ${request.loggedIn}");
    // print("Current session ID: ${request.cookies['sessionid']}"); // Debug print
    
    try {
        // Add headers explicitly
        Map<String, dynamic> formData = {
            'content': content,
            'rating': rating.toString(),
            // 'sessionid': request.cookies['sessionid'], // Add session ID to form data
        };

        print("Sending request with data: $formData"); // Debug print
        
        final response = await request.post(
            '$baseUrl/flutter/edit_comment/$commentId/',
            formData,
        );
        
        print("Edit comment response: $response");
        
        if (response['status'] == 'error') {
            throw Exception(response['message']);
        }
    } catch (e) {
        print("Error editing comment: $e");
        throw Exception('Failed to edit comment: $e');
    }
  }


  Future<void> deleteComment(int commentId) async {
    print("Deleting comment ID: $commentId");
    
    try {
      final response = await request.post(
        '$baseUrl/flutter/delete_comment/$commentId/',
        {},
      );
      
      print("Delete comment response: $response");
      
      if (response['status'] == 'error') {
        throw Exception(response['message']);
      }
    } catch (e) {
      print("Error deleting comment: $e");
      throw Exception('Failed to delete comment: $e');
    }
  }

  Future<void> buySouvenir(int souvenirId) async {
    print("Buying souvenir ID: $souvenirId");
    
    try {
      final response = await request.post(
        '$baseUrl/flutter/buy_souvenir/$souvenirId/',
        {},
      );
      
      print("Buy souvenir response: $response");
      
      if (response['status'] == 'error') {
        throw Exception(response['message']);
      }
    } catch (e) {
      print("Error buying souvenir: $e");
      throw Exception('Failed to purchase souvenir: $e');
    }
  }
}