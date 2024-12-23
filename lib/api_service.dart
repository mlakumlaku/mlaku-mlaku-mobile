import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mlaku_mlaku/models/itinerary_model.dart';

class ApiService {
  final String baseUrl = "https://nur-khoirunnisa-mlakumlaku2.pbp.cs.ui.ac.id/api/";

  Future<List<Itinerary>> fetchItineraries() async {
    final response = await http.get(Uri.parse("${baseUrl}itineraries/"));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Itinerary.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load itineraries");
    }
  }
}
