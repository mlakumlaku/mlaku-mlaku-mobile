import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mlaku_mlaku/screens/create_itinerary_screen.dart';
import 'package:mlaku_mlaku/widgets/bottom_navbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Fungsi untuk mengambil data itinerary dari API
  Future<List<dynamic>> fetchItineraries() async {
    final response = await http.get(Uri.parse('https://malika-atha31-mlakumlaku.pbp.cs.ui.ac.id'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data; // Mengembalikan data itinerary
    } else {
      throw Exception('Failed to load itineraries');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[900],
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,  // Centering content vertically
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Itinerary',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Where exploring shared travel plans sparks ',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: 'inspiration',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                        TextSpan(
                          text: '\nand setting your dream journey becomes ',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: 'effortless',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                        TextSpan(
                          text: '.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateItineraryScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Plan your tour',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                // FutureBuilder to fetch and display the itineraries
                FutureBuilder<List<dynamic>>(
                  future: fetchItineraries(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      );
                    } else if (snapshot.hasData) {
                      List<dynamic> itineraries = snapshot.data!;
                      return Column(
                        children: List.generate(itineraries.length, (index) {
                          var itinerary = itineraries[index];
                          String itineraryName = itinerary['name'] ?? 'No name available';
                          var days = itinerary['days'] as List<dynamic>;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    itineraryName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,  // Centering text in the card
                                  ),
                                  const SizedBox(height: 10),
                                  Column(
                                    children: List.generate(days.length, (dayIndex) {
                                      var day = days[dayIndex];
                                      String dayNumber = 'Day ${day['day_number']}';
                                      String date = day['date'];
                                      var destinations = day['destinations'] as List<dynamic>;

                                      return Column(
                                        children: [
                                          Text(
                                            '$dayNumber - $date',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,  // Centering text in the card
                                          ),
                                          const SizedBox(height: 5),
                                          Column(
                                            children: List.generate(destinations.length, (destIndex) {
                                              var destination = destinations[destIndex];
                                              String destinationName = destination['name'] ?? 'No name';
                                              String time = destination['time'] ?? 'No time available';

                                              return Padding(
                                                padding: const EdgeInsets.only(left: 0.0),
                                                child: Text(
                                                  '$destinationName at $time',
                                                  style: const TextStyle(color: Colors.black87),
                                                  textAlign: TextAlign.center,  // Centering text in the card
                                                ),
                                              );
                                            }),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    } else {
                      return const Text('No itineraries available', style: TextStyle(color: Colors.white));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
