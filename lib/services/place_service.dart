// // // lib/services/place_service.dart
// // import 'package:pbp_django_auth/pbp_django_auth.dart';
// // import '../models/place.dart';
// // import 'dart:convert';                     // for jsonEncode
// // import 'package:http/http.dart' as http;   // for http.post

// // class PlaceService {
// //   final CookieRequest request;

// //   PlaceService(this.request);

// //   Future<Place> fetchPlaceDetail(int placeId) async {
// //     final url =
// //         'http://127.0.0.1:8000/places/$placeId/json/'; // Use your local IP
// //     final response = await request.get(url);
// //     return Place.fromJson(response);
// //   }

// //   Future<bool> addComment(int placeId, String content, int rating) async {
// //     final url = 'http://127.0.0.1:8000/places/add_comment/$placeId/';

// //     // final response = await request.post(url, {
// //     //   'comment': content,
// //     //   'rating': rating.toString(),
// //     // });

// //     final response = await request.client.post(
// //       url,
// //       headers: {
// //         'Content-Type': 'application/json',
// //         'X-Requested-With': 'XMLHttpRequest',
// //         // If you need a CSRF token, also set 'X-CSRFToken': ...
// //         // But since @csrf_exempt is used, we might not need it
// //       },
// //       // JSON-encode the body:
// //       body: jsonEncode({
// //         'comment': content,
// //         'rating': rating,
// //       }),
// //     );

// //     if (response.statusCode == 201) {
// //       // Success from server
// //       return true;
// //     } else {
// //       // Attempt to parse JSON error from server
// //       final body = jsonDecode(response.body);
// //       final error = body['error'] ?? 'Unknown error';
// //       throw Exception(error);
// //     }
// //   }
// // }
// // //TRIAL UPDATE 3
// // // lib/services/place_service.dart
// // import 'dart:convert';                     // for jsonEncode, jsonDecode
// // import 'package:http/http.dart' as http;   // for http.post, http.get, etc.
// // import 'package:pbp_django_auth/pbp_django_auth.dart';
// // import '../models/place.dart';

// // class PlaceService {
// //   final CookieRequest request;

// //   // Constructor: pass in the same CookieRequest used for login
// //   PlaceService(this.request);

// //   /// 1) Fetch place detail with the built-in CookieRequest.get.
// //   ///    This automatically includes your session cookie from login.
// //   Future<Place> fetchPlaceDetail(int placeId) async {
// //     // Example endpoint in Django: http://127.0.0.1:8000/places/<placeId>/json/
// //     final url = 'http://127.0.0.1:8000/places/$placeId/json/';

// //     // CookieRequest.get() returns dynamic JSON; parse it into a Place.
// //     final response = await request.get(url);

// //     // 'response' is already decoded (CookieRequest does JSON decoding automatically
// //     // if your response is application/json). But if needed, you can do
// //     //  final decoded = jsonDecode(response);
// //     // We'll assume 'response' is a Map that fits the Place.fromJson constructor.
// //     return Place.fromJson(response);
// //   }

// //   /// 2) Add a comment in **raw JSON**.
// //   ///    We manually attach the session cookie from CookieRequest to an http.post request.
// //   Future<bool> addComment(int placeId, String content, int rating) async {
// //     // The Django endpoint for adding a comment
// //     final url = Uri.parse('http://127.0.0.1:8000/places/add_comment/$placeId/');

// //     // Extract the existing session cookie from CookieRequest
// //     // so Django recognizes the user is authenticated.
// //     final sessionCookie = request.headers['Cookie'] ?? '';

// //     // Manually make the post request using the http package
// //     final response = await http.post(
// //       url,
// //       headers: {
// //         'Content-Type': 'application/json',
// //         'X-Requested-With': 'XMLHttpRequest',
// //         // Attach the session cookie from CookieRequest
// //         'Cookie': sessionCookie,
// //       },
// //       // Encode the Dart map as JSON
// //       body: jsonEncode({
// //         'comment': content,
// //         'rating': rating,
// //       }),
// //     );

// //     // Evaluate the response
// //     if (response.statusCode == 201) {
// //       // Django returned success
// //       return true;
// //     } else {
// //       // Possibly an error from Django
// //       try {
// //         final body = jsonDecode(response.body);
// //         final error = body['error'] ?? 'Unknown error';
// //         throw Exception(error);
// //       } catch (e) {
// //         // If there's no valid JSON or no 'error' field
// //         throw Exception('Failed to add comment. Status: ${response.statusCode}');
// //       }
// //     }
// //   }
// // }
// // //end trial udpate 3
// //TRIAL FIN CAPE
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import '../models/place.dart';

// class PlaceService {
//   final CookieRequest request;

//   PlaceService(this.request);

//   Future<Place> fetchPlaceDetail(int placeId) async {
//     final url = 'http://127.0.0.1:8000/places/$placeId/json/';
//     final response = await request.get(url);
//     return Place.fromJson(response);
//   }

//   Future<bool> addComment(int placeId, String content, int rating) async {
//     final url = Uri.parse('http://127.0.0.1:8000/places/add_comment/$placeId/');
//     final sessionCookie = request.headers['Cookie'] ?? '';

//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'X-Requested-With': 'XMLHttpRequest',
//           'Cookie': sessionCookie,
//         },
//         body: jsonEncode({
//           'comment': content,
//           'rating': rating,
//         }),
//       );

//       // Check if the response has a body
//       if (response.body.isNotEmpty) {
//         final responseData = jsonDecode(response.body);

//         // Check status code ranges
//         if (response.statusCode >= 200 && response.statusCode < 300) {
//           return true;
//         } else {
//           // Get error message from response if available
//           final error = responseData['error'] ?? 'Unknown error occurred';
//           throw Exception(error);
//         }
//       } else {
//         // Handle empty response
//         if (response.statusCode >= 200 && response.statusCode < 300) {
//           return true;
//         } else {
//           throw Exception('Failed to add comment. Status: ${response.statusCode}');
//         }
//       }
//     } catch (e) {
//       // Handle any JSON decode errors or network issues
//       throw Exception('Failed to add comment: $e');
//     }
//   }
// }

// //END TRIAL FIN CAPE

//startover claude
// // services/place_service.dartimport 'package:pbp_django_auth/pbp_django_auth.dart';
// // lib/services/place_service.dart
// import 'dart:convert';

// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import '../models/place.dart';

// class PlaceService {
//   final CookieRequest request;

//   PlaceService(this.request);

//   Future<Place> getPlaceDetails(int placeId) async {
//     print("Fetching place details for ID: $placeId");
//     final response = await request.get(
//       'http://127.0.0.1:8000/places/$placeId/json/',
//     );
//     print("Place details response: $response");
//     return Place.fromJson(response);
//   }

//   Future<void> addComment(int placeId, String content, int rating) async {
//       print("Adding comment for place ID: $placeId");
//       print("Comment data: content=$content, rating=$rating");
      
//       try {
//           // Using formData format instead of JSON
//           final response = await request.post(
//               'http://127.0.0.1:8000/places/add_comment/$placeId/',
//               {
//                   'comment': content,
//                   'rating': rating.toString(),
//               },
//           );
          
//           print("Add comment response: $response");
          
//           // If we get an error response, throw it
//           if (response is Map && response.containsKey('error')) {
//               throw Exception(response['error']);
//           }
          
//       } catch (e) {
//           print("Error adding comment: $e");
//           throw Exception('Failed to add comment: $e');
//       }
//   }
// //   Future<void> addComment(int placeId, String content, int rating) async {
// //     print("Adding comment for place ID: $placeId");
// //     print("Comment data: content=$content, rating=$rating");
// //     print("Current login status: ${request.loggedIn}");
// //     print("Current cookies: ${request.headers['cookie']}");
    
// //     try {
// //         final response = await request.post(
// //             'http://127.0.0.1:8000/places/add_comment/$placeId/',
// //             {
// //                 'comment': content,
// //                 'rating': rating.toString(),
// //             },
// //         );
        
// //         print("Add comment response: $response");

// //         if (response is Map && response['status'] == 'error') {
// //             throw Exception(response['message']);
// //         }
        
// //     } catch (e) {
// //         print("Error adding comment: $e");
// //         throw Exception('Failed to add comment: $e');
// //     }
// // }
    
//   Future<void> editComment(int commentId, String content, int rating) async {
//     print("Editing comment ID: $commentId");
//     final response = await request.post(
//       'http://127.0.0.1:8000/places/comment/$commentId/edit/',
//       {
//         'content': content,
//         'rating': rating.toString(),
//       },
//     );
//     print("Edit comment response: $response");

//     if (response['status'] == false) {
//       throw Exception(response['message'] ?? 'Failed to edit comment');
//     }
//   }

//   Future<void> deleteComment(int commentId) async {
//     print("Deleting comment ID: $commentId");
//     final response = await request.post(
//       'http://127.0.0.1:8000/places/comment/$commentId/delete/',
//       {},
//     );
//     print("Delete comment response: $response");

//     if (response['status'] == false) {
//       throw Exception(response['message'] ?? 'Failed to delete comment');
//     }
//   }

//   Future<void> buySouvenir(int souvenirId) async {
//     print("Buying souvenir ID: $souvenirId");
//     final response = await request.post(
//       'http://127.0.0.1:8000/places/buy/$souvenirId/',
//       {},
//     );
//     print("Buy souvenir response: $response");

//     if (response['status'] == false) {
//       throw Exception(response['message'] ?? 'Failed to purchase souvenir');
//     }
//   }

  
// } // end startover claude


// 2ND START OVER CLAUDE

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