import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place.dart';

class ApiService {
  final String apiUrl = "http://127.0.0.1:8000/get-places/"; // Update with your API endpoint

  Future<List<Place>> fetchPlaces() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> jsonData = jsonResponse['places']; // Access the 'places' key
      return jsonData.map((json) => Place.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load places');
    }
  }
}