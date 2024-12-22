// lib/screens/itinerary_card.dart
import 'package:flutter/material.dart';
import '../models/itinerary_model.dart';  // Make sure to adjust this path if needed

class ItineraryCard extends StatelessWidget {
  final Itinerary itinerary;

  const ItineraryCard({super.key, required this.itinerary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Itinerary Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.grey[800],
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itinerary.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                // Display the itinerary days in a loop
                for (var day in itinerary.days) ...[
                  Text(
                    'Day ${day.dayNumber}: ${day.dateController.text}',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  // Display the destinations for each day
                  for (var destination in day.destinations) ...[
                    Text(
                      'Destination: ${destination.name}, Time: ${destination.timeController.text}',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                  ],
                  const Divider(color: Colors.white),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
