import 'package:flutter/material.dart';
import '../../journal/screens/journal_home.dart';
import '../../models/collections.dart';
import '../../widgets/bottom_navbar.dart';
import 'collection_places_screen.dart';

class CollectionsScreen extends StatelessWidget {
  final List<Collection> collections;

  const CollectionsScreen({Key? key, required this.collections}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collections'),
      ),
      body: collections.isEmpty
          ? const Center(child: Text('No collections available.'))
          : ListView.builder(
              itemCount: collections.length,
              itemBuilder: (context, index) {
                final collection = collections[index];
                return Card(
                  child: ListTile(
                    title: Text(collection.name),
                    subtitle: Text('Created: ${collection.createdAt}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CollectionPlacesScreen(
                            collectionId: collection.id,
                            collectionName: collection.name,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavBar(
        onTap: (index) {
          if (index == 3) {
            // Navigasi ke halaman jurnal home
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JournalHome()), // Ganti dengan halaman yang sesuai
            );
          }
          // Tambahkan aksi untuk item lain jika diperlukan
        },
      ),
    );
  }
}
