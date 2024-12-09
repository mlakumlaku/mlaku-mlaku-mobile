import 'package:flutter/material.dart';
import 'package:mlaku_mlaku/journal/screens/journal_home.dart';
import '../../models/collections.dart';
import 'collection_places_screen.dart';
import '../../widgets/bottom_navbar.dart';

class CollectionsScreen extends StatelessWidget {
  final List<Collection> collections;

  const CollectionsScreen({super.key, required this.collections});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Collections',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white,),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF282A3A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.flag, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      '15 Items',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.visibility, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      '1,891 Views',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add functionality for creating a collection
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Create',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: collections.length,
                itemBuilder: (context, index) {
                  final collection = collections[index];
                  return GestureDetector(
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
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://via.placeholder.com/150', // Replace with your image URL
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  collection.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Created ${collection.createdAt}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: collection.places.take(3).map((place) {
                                    return Chip(
                                      label: Text(
                                        place.placeName,
                                        style: const TextStyle(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList()
                                    ..addIf(
                                      collection.places.length > 3,
                                      Chip(
                                        label: Text(
                                          '+${collection.places.length - 3} more',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF282A3A),
      bottomNavigationBar: BottomNavBar(
        onTap: (index) {
          if (index == 2) {
            // Navigate to the journal home
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JournalHome()), // Replace with your journal screen
            );
          } else if (index == 0) {
            // Handle home navigation
            Navigator.popUntil(context, (route) => route.isFirst);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Page not available')),
            );
          }
        },
      ),
    );
  }
}

extension ListExtensions<T> on List<T> {
  void addIf(bool condition, T value) {
    if (condition) add(value);
  }
}
