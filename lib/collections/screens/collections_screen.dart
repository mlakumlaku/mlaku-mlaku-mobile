import 'package:flutter/material.dart';
import '../../models/collections.dart';

class CollectionsScreen extends StatelessWidget {
  final List<Collection> collections;

  const CollectionsScreen({required this.collections});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Collections'),
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
                    subtitle: Text('Created on: ${collection.createdAt}'),
                  ),
                );
              },
            ),
    );
  }
}
