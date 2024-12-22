import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/itinerary_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ItineraryProvider(), // Inisialisasi ItineraryProvider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MlakuMlaku',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(), // Menampilkan layar HomeScreen pertama kali
    );
  }
}
