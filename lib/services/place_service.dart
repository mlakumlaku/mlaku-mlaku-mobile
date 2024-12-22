import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/place.dart';

class PlaceService {
  final CookieRequest request;

  PlaceService(this.request);

  Future<Place> fetchPlaceDetail(int placeId) async {
    try {
      // Make sure this URL matches your Django development server
      final url = 'http://localhost:8000/places/$placeId/json/';
      
      // Add necessary headers
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      
      final response = await request.get(url);
      
      // Debug print to see the response
      print('Response from server: $response');
      
      if (response is String) {
        // If response is String, parse it to JSON first
        return placeFromJson(response);
      } else {
        // If response is already Map<String, dynamic>
        return Place.fromJson(response);
      }
    } catch (e) {
      print('Error fetching place detail: $e');
      throw Exception('Failed to fetch place detail: $e');
    }
  }

  Future<bool> addComment(int placeId, String content, int rating) async {
    try {
      request.headers['X-Requested-With'] = 'XMLHttpRequest';
      
      final response = await request.post(
        'http://localhost:8000/places/add_comment/$placeId/',
        {
          'comment': content,
          'rating': rating.toString(),
        },
      );

      if (response['error'] != null) {
        throw Exception(response['error']);
      }
      return true;
    } catch (e) {
      print('Error adding comment: $e');
      throw Exception('Failed to add comment: $e');
    }
  }
}