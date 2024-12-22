import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mlaku_mlaku/screens/login.dart';
import 'widgets/bottom_navbar.dart';
import 'package:mlaku_mlaku/journal/screens/journal_home.dart';
import 'package:mlaku_mlaku/screens/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mlaku_mlaku/place/screens/place_detail_page.dart';


void main() {
  runApp(
    ChangeNotifierProvider<CustomCookieRequest>(
      create: (context) => CustomCookieRequest(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<CustomCookieRequest>(); // Ambil objek pengguna saat ini
    final userName = currentUser.userName; // Ambil nama pengguna

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
        home: Scaffold(
          appBar: AppBar(
            title: Text('Welcome to Mlaku-Mlaku!'), // Tampilkan nama pengguna di AppBar
          ),
          body: const LoginPage(), // Halaman login
        ),
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
    // Obtain the CookieRequest instance from Provider
    final request = Provider.of<CookieRequest>(context, listen: false);
    final currentUser = context.read<CustomCookieRequest>(); // Get current user object
    final userName = currentUser.userName;
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
                  Text(
                    '$userName', // Tampilkan nama pengguna
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                // **Step 1:** Define your Django logout URL
                // Replace '192.168.x.x' with your actual local IP address
                // Ensure that this URL matches your Django logout endpoint
                final logoutUrl = 'http://127.0.0.1:8000/accounts/logout/';

                try {
                  // **Step 2:** Call the logout method with the logout URL
                  await request.logout(logoutUrl);

                  // **Step 3:** Navigate back to the LoginPage after successful logout
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                } catch (e) {
                  // **Step 4:** Handle any errors during logout
                  print("Logout error: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('An error occurred during logout.')),
                  );
                }
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
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  _buildCard('Bukit Bintang Yogyakarta', 'assets/templeborobudur.jpeg', placeId: 1),
                  _buildCard('Bukit Lintang Sewu', 'assets/bunker_kaliadem.jpg', placeId: 2),
                  _buildCard('Bukit Paralayang, Watugupit', 'assets/de_mata_museum.jpg', placeId: 3),
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

  Widget _buildCard(String title, String imagePath, {required int placeId}) {
    return GestureDetector(
      onTap: () {
        // Navigate to the detail page for this place
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetailScreen(placeId: placeId),
          ),
        );
      },
      child: Card(
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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'screens/home_screen.dart';
// import 'providers/itinerary_provider.dart';

// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => ItineraryProvider(), // Inisialisasi ItineraryProvider
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'MlakuMlaku',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const HomeScreen(), // Menampilkan layar HomeScreen pertama kali
//     );
//   }
// }
