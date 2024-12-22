import 'package:flutter/material.dart';

class Destination {
  late final String name;
  late final TimeOfDay? time;

  // Adding a TextEditingController for time (we'll handle formatting later in UI)
  TextEditingController timeController = TextEditingController();

  // Constructor
  Destination({required this.name, this.time});

  // Factory constructor to create a Destination from JSON data
  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      name: json['name'],
      time: json['time'] != null
          ? _parseTime(json['time']) // Parse the time string into TimeOfDay
          : null,
    );
  }

  // Helper function to parse time string into TimeOfDay
  static TimeOfDay _parseTime(String timeString) {
    final timeParts = timeString.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}

// Model for Day in Itinerary
class ItineraryDay {
  final int dayNumber;
  late final String date;
  final List<Destination> destinations;

  // Adding a TextEditingController for the date field
  TextEditingController dateController = TextEditingController();

  ItineraryDay({
    required this.dayNumber,
    required this.date,
    required this.destinations,
  }) {
    // Initialize the dateController with the initial date value
    dateController.text = date;
  }

  // Factory constructor to create an ItineraryDay from JSON data
  factory ItineraryDay.fromJson(Map<String, dynamic> json) {
    var list = json['destinations'] as List;
    List<Destination> destinationsList = list.map((e) => Destination.fromJson(e)).toList();

    return ItineraryDay(
      dayNumber: json['day_number'],
      date: json['date'],
      destinations: destinationsList,
    );
  }
}

// Model for Itinerary
class Itinerary {
  final int id;
  final String name;
  final String coverImagePath;
  final List<ItineraryDay> days;

  Itinerary({
    required this.id,
    required this.name,
    required this.coverImagePath,
    required this.days,
  });

  // Factory constructor to create an Itinerary from JSON data
  factory Itinerary.fromJson(Map<String, dynamic> json) {
    var list = json['days'] as List;
    List<ItineraryDay> daysList = list.map((e) => ItineraryDay.fromJson(e)).toList();

    return Itinerary(
      id: json['id'],
      name: json['name'],
      coverImagePath: json['cover'] ?? '',  // Handle potential null cover
      days: daysList,
    );
  }
}
