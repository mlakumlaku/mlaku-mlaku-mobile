import 'package:flutter/material.dart';
import 'package:mlaku_mlaku_mobile/home.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    DevicePreview(
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Health Tracker',
      theme: ThemeData(
        fontFamily: 'Geist',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ).copyWith(secondary: Colors.deepPurple[400]),
        textTheme: const TextTheme(
          displayLarge: TextStyle(letterSpacing: -0.25),
          displayMedium: TextStyle(letterSpacing: -0.25),
          displaySmall: TextStyle(letterSpacing: -0.25),
          headlineLarge: TextStyle(letterSpacing: -0.25),
          headlineMedium: TextStyle(letterSpacing: -0.25),
          headlineSmall: TextStyle(letterSpacing: -0.25),
          titleLarge: TextStyle(letterSpacing: -0.25),
          titleMedium: TextStyle(letterSpacing: -0.25),
          titleSmall: TextStyle(letterSpacing: -0.25),
          bodyLarge: TextStyle(letterSpacing: -0.25),
          bodyMedium: TextStyle(letterSpacing: -0.25),
          bodySmall: TextStyle(letterSpacing: -0.25),
          labelLarge: TextStyle(letterSpacing: -0.25),
          labelMedium: TextStyle(letterSpacing: -0.25),
          labelSmall: TextStyle(letterSpacing: -0.25),
        ),
      ),
      home: const HomePage(),
    );
  }
}