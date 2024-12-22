import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mlaku_mlaku/screens/login.dart';
import 'widgets/bottom_navbar.dart';
import 'package:mlaku_mlaku/journal/screens/journal_home.dart';
import 'package:flutter/foundation.dart';
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
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Mlaku-Mlaku',
        theme: ThemeData(
          primaryColor: Colors.blueAccent,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
          ).copyWith(secondary: Colors.redAccent),
          scaffoldBackgroundColor: Colors.white,
          textTheme: TextTheme(
            bodyLarge: const TextStyle(color: Colors.black),
            bodyMedium: const TextStyle(color: Colors.black54),
          ),
        ),
        home: const LoginPage(),
      ),
    );
  }
}

// Destination class to structure our data
class Destination {
  final int id;
  final String name;
  final String description;
  final String imagePath;

  Destination({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
  });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Complete list of destinations from the dataset
  // Inside _MyHomePageState class, replace the existing destinations list with:
final List<Destination> destinations = [
    Destination(
      id: 1,
      name: "Bukit Bintang Yogyakarta",
      description: "Bukit Bintang merupakan salah satu lokasi nongkrong favorit di Yogyakarta. Saat malam tiba, pemandangan Yogyakarta sangatlah indah!",
      imagePath: "assets/images/defaultpic.jpg"
    ),
    Destination(
      id: 2,
      name: "Bukit Lintang Sewu",
      description: "Bukit Lintang Sewu ini berasal ketika pada saat malam hari di bukit ini terlihat ribuan bintang yang membentang luas di angkasa.",
      imagePath: "assets/images/defaultpic.jpg"
    ),
    Destination(
      id: 3,
      name: "Bukit Paralayang, Watugupit",
      description: "Bukit Paralayang Parangtritis merupakan tempat wisata di Yogyakarta yang mensajikan pemandangan pantai parangtritis dari ketinggian 900 mdpl.",
      imagePath: "assets/images/defaultpic.jpg"
    ),
    Destination(
      id: 4,
      name: "Bukit Wisata Pulepayung",
      description: "Pule Payung Yogyakarta adalah objek wisata populer yang menyajikan keindahan alam dari ketinggian 500 mdpl.",
      imagePath: "assets/images/defaultpic.jpg"
    ),
    Destination(
      id: 5,
      name: "Bunker Kaliadem Merapi",
      description: "Bunker Kaliadem merupakan objek wisata yang terletak di lereng selatan Gunung Merapi.",
      imagePath: "assets/images/defaultpic.jpg"
    ),
    Destination(
      id: 6,
      name: "Candi Prambanan",
      description: "Candi Prambanan adalah kompleks candi Hindu terbesar di Indonesia yang dibangun pada abad ke-9 masehi.",
      imagePath: "assets/images/defaultpic.jpg"
    ),
    Destination(
      id: 7,
      name: "De Mata Museum Jogja",
      description: "Museum De Mata merupakan salah satu museum yang berisi lukisan 3D terbanyak di dunia.",
      imagePath: "assets/images/defaultpic.jpg"
    ),
    Destination(
      id: 8,
      name: "Goa Pindul",
      description: "Gua Pindul adalah objek wisata berupa gua yang terletak di Desa Bejiharjo, dikenal dengan cave tubing.",
      imagePath: "assets/images/defaultpic.jpg"
    ),
    Destination(
      id: 9,
      name: "Gumuk Pasir Parangkusumo",
      description: "Gumuk Pasir Parangkusumo adalah objek wisata di Kabupaten Bantul, Yogyakarta.",
      imagePath: "assets/images/defaultpic.jpg"
    ),
    Destination(
      id: 10,
      name: "Heha Sky View",
      description: "HeHa Sky View adalah salah satu tempat wisata terbaru di Yogyakarta dengan konsep selfie, resto, dan food stalls.",
      imagePath: "assets/images/defaultpic.jpg"
    ),
    Destination(
      id: 11,
      name: "Kampung Wisata Dipowinatan",
      description: "Kampung wisata yang menawarkan konsep live in dan pengalaman budaya Jawa yang otentik.",
      imagePath: "assets/images/defaultpic.jpg"
    ),
    Destination(
      id: 12,
      name: "Desa Wisata Gamplong",
      description: "Desa wisata kerajinan tenun tradisional dengan Alat Tenun Bukan Mesin (ATBM).",
      imagePath: "assets/images/defaultpic.jpg"
    ),
    Destination(
      id: 13,
      name: "Desa Wisata Pulesari",
      description: "Desa wisata yang menawarkan pengalaman budaya, kuliner, dan keindahan alam Yogyakarta.",
      imagePath: "assets/images/defaultpic.jpg"
    ),
    Destination(
      id: 14,
      name: "Desa Wisata Rumah Domes",
      description: "Kawasan unik dengan rumah-rumah berbentuk dome yang menyerupai rumah Teletubbies.",
      imagePath: "assets/images/defaultpic.jpg"
    ),
    Destination(
      id: 15,
      name: "Desa Wisata Tembi",
      description: "Desa wisata yang menggabungkan potensi alam, sejarah, dan budaya dalam satu kawasan.",
      imagePath: "assets/images/defaultpic.jpg"
    ),
    Destination(
      id: 16,
      name: "Galaxy Waterpark Jogja",
      description: "Taman rekreasi air modern dengan berbagai wahana air untuk segala usia.",
      imagePath: "assets/images/defaultpic.jpg"
    ),
    Destination(
      id: 17,
      name: "Museum Gunung Merapi",
      description: "Museum yang memberikan informasi dan pengalaman tentang Gunung Merapi.",
      imagePath: "assets/images/defaultpic.jpg"
    ),
];


  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context, listen: false);
    final currentUser = context.read<CustomCookieRequest>();
    final userName = currentUser.userName;
    
    return Scaffold(
      backgroundColor: const Color(0xFF282A3A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF282A3A),
        title: Row(
          children: [
            const Expanded(
              child: Text(
                'Mlaku-Mlaku',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    userName ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                final logoutUrl = 'http://127.0.0.1:8000/accounts/logout/';
                try {
                  await request.logout(logoutUrl);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('An error occurred during logout.')),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: const [
                    Text(
                      'Touring Across Yogyakarta',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Start your next unforgettable trip with MlakuMaku!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.redAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'A Hub for Local Excellence',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Yogyakarta, where ancient heritage and vibrant culture intertwine, offers a captivating journey through Indonesias heart.',
                style: TextStyle(fontSize: 14, color: Colors.white54),
              ),
              const SizedBox(height: 24),

              // New GridView for destinations
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                itemCount: destinations.length,
                itemBuilder: (context, index) {
                  return _buildDestinationCard(destinations[index]);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JournalHome()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Page belum tersedia')),
            );
          }
        },
      ),
    );
  }

  Widget _buildDestinationCard(Destination destination) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaceDetailScreen(placeId: destination.id),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: Image.asset(
                destination.imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    destination.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}