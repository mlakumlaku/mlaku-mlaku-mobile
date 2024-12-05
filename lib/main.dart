// lib/main.dart

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mlaku_mlaku/screens/login.dart';
import 'widgets/bottom_navbar.dart';
import 'package:mlaku_mlaku/journal/screens/journal_home.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Mlaku-Mlaku',
        theme: ThemeData(
          primaryColor: Colors.blueAccent, // Warna utama
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
          ).copyWith(secondary: Colors.redAccent), // Menambahkan warna aksen
          scaffoldBackgroundColor: Colors.white, // Latar belakang putih
          textTheme: TextTheme(
            bodyLarge: const TextStyle(color: Colors.black), // Teks hitam
            bodyMedium: const TextStyle(color: Colors.black54), // Teks abu-abu
          ),
        ),
        home: const LoginPage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282A3A), // Ubah warna latar belakang di sini
      appBar: AppBar(
        backgroundColor: const Color(0xFF282A3A), // Warna latar belakang AppBar
        title: Row(
          children: [
            const Expanded(
              child: Text(
                'Mlaku-Mlaku',
                textAlign: TextAlign.center, // Menjaga teks di tengah
                style: TextStyle(
                  color: Colors.white, // Warna teks putih
                  fontSize: 28, // Ganti dengan ukuran font yang diinginkan
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.white), // Ikon pengguna
                  const SizedBox(width: 4),
                  const Text(
                    'tesbaru', // Ganti dengan nama pengguna yang sesuai
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white), // Ikon logout
              onPressed: () {
                // Navigasi kembali ke halaman login
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Text(
                'Touring Across Yogyakarta',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: const Text(
                'Start your next unforgettable trip with MlakuMaku!',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.redAccent,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'A Hub for Local Excellence',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Warna hitam
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Yogyakarta, where ancient heritage and vibrant culture intertwine, offers a captivating journey through Indonesia’s heart. Explore the majestic Borobudur and Prambanan temples, both UNESCO World Heritage Sites, that stand as timeless symbols of history. From traditional Javanese art to modern creativity, Yogyakarta is a melting pot of inspiration and innovation. Experience the warmth of its people and the rich flavors of its cuisine, making every visit unforgettable.',
              style: TextStyle(fontSize: 14, color: Colors.white54),
            ),
            const SizedBox(height: 16),
            // Tambahkan konten lain di sini jika diperlukan
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  _buildCard('Bukit Lintang Sewu', 'assets/bukit_lintang_sewu.jpg'),
                  _buildCard('Bunker Kaliadem Merapi', 'assets/bunker_kaliadem.jpg'),
                  _buildCard('De Mata Museum Jogja', 'assets/de_mata_museum.jpg'),
                ],
              ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: BottomNavBar(
        onTap: (index) {
          // Handle navigation based on the index
          if (index == 0) {
            // Navigate to Home
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (index == 1) {
            // Navigate to Journals
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JournalHome()), // Ganti dengan halaman yang sesuai
            );
          } else {
            // Show snackbar for other items
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Page belum tersedia')),
            );
          }
        },
      ),
    );
  }

  Widget _buildCard(String title, String imagePath) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}