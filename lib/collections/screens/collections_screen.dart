import 'package:flutter/material.dart';
import '../../models/collections.dart';
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
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: collections.length,
        itemBuilder: (context, index) {
          final collection = collections[index];

          return GestureDetector(
            onTap: () {
              // Navigate to CollectionPlacesScreen when card is tapped
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
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://via.placeholder.com/150', // Replace with dynamic image if available
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      collection.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Created ${collection.createdAt}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 4,
                      children: collection.places.take(3).map((place) {
                        return Chip(
                          label: Text(
                            place.placeName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList()
                        ..addIf(collection.places.length > 3, Chip(label: Text('+${collection.places.length - 3} more'))),
                    ),
                  ),
                ],
              ),
            ),
          );
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
