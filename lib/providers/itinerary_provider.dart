import 'package:flutter/foundation.dart';
import '../models/itinerary_model.dart';

class ItineraryProvider extends ChangeNotifier {
  final List<Itinerary> _itineraries = []; 

  List<Itinerary> get itineraries => _itineraries;

  void addItinerary(Itinerary itinerary) {
    _itineraries.add(itinerary);
    notifyListeners();
  }

  void updateItinerary(int index, Itinerary itinerary) {
    _itineraries[index] = itinerary;
    notifyListeners();
  }

  void deleteItinerary(int index) {
    _itineraries.removeAt(index);
    notifyListeners();
  }
}
