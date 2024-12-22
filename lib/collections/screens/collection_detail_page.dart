// lib/screens/collection_detail_page.dart
import 'package:flutter/material.dart';
import 'package:mlaku_mlaku/models/collections.dart';
import 'package:mlaku_mlaku/models/place.dart';
import 'package:mlaku_mlaku/place/screens/place_detail_page.dart';
import 'package:mlaku_mlaku/services/collection_services.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CollectionDetailPage extends StatefulWidget {
  final Collection collection;

  const CollectionDetailPage({Key? key, required this.collection}) : super(key: key);

  @override
  State<CollectionDetailPage> createState() => _CollectionDetailPageState();
}

class _CollectionDetailPageState extends State<CollectionDetailPage> {
  late CollectionService _collectionService;
  late Future<List<Place>> _placesFuture;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    _collectionService = CollectionService(request);
    _refreshPlaces();
  }

  void _refreshPlaces() {
    setState(() {
      _placesFuture = _collectionService.getCollectionPlaces(widget.collection.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collection.name),
      ),
      body: FutureBuilder<List<Place>>(
        future: _placesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final places = snapshot.data!;
          if (places.isEmpty) {
            return const Center(
              child: Text('No places in this collection yet.'),
            );
          }

          return ListView.builder(
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(place.name),
                  subtitle: Text(place.description),
                  trailing: Text('Rating: ${place.averageRating}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceDetailScreen(placeId: place.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}