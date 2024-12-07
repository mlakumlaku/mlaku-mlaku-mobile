import 'package:flutter/material.dart';
import '../../models/collections.dart';
import '../../models/place.dart';

class CollectionPlacesScreen extends StatelessWidget {
  final Collection collection;

  CollectionPlacesScreen({required this.collection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(collection.name),
      ),
      body: collection.places.isEmpty
          ? const Center(
              child: Text("No places in this collection."),
            )
          : ListView.builder(
              itemCount: collection.places.length,
              itemBuilder: (context, index) {
                final place = collection.places[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        // Ganti URL dengan atribut gambar dari Place jika ada
                        'https://via.placeholder.com/150',
                      ),
                    ),
                    title: Text(place.placeName),
                    subtitle: Text(place.descriptionPlace),
                    onTap: () {
                      // Tambahkan logika untuk navigasi ke detail tempat
                    },
                  ),
                );
              },
            ),
    );
  }
}
