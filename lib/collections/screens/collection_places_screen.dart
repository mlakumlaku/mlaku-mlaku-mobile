import 'package:flutter/material.dart';
import 'package:mlaku_mlaku/place/screens/place_detail_page.dart';
import '../../models/place.dart';
import '../../services/collection_services.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CollectionPlacesScreen extends StatefulWidget {
  final int collectionId;
  final String collectionName;

  const CollectionPlacesScreen({
    Key? key,
    required this.collectionId,
    required this.collectionName,
  }) : super(key: key);

  @override
  _CollectionPlacesScreenState createState() => _CollectionPlacesScreenState();
}

class _CollectionPlacesScreenState extends State<CollectionPlacesScreen> {
  final CollectionService _collectionService = CollectionService();
  List<Place> _places = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlaces();
  }

  Future<void> _fetchPlaces() async {
    final request = context.read<CookieRequest>(); // Get CookieRequest from Provider
    try {
      final places = await _collectionService.fetchCollectionPlaces(widget.collectionId, request);
      setState(() {
        _places = places;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteCollection() async {
    final request = context.read<CookieRequest>();
    try {
      await _collectionService.deleteCollection(request, widget.collectionId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Collection deleted successfully!')),
        );
        Navigator.pop(context); // Navigate back to the collections page
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete collection: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collectionName),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Delete Collection'),
                    content: const Text('Are you sure you want to delete this collection?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );

              if (shouldDelete == true) {
                _deleteCollection();
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _places.isEmpty
              ? const Center(child: Text('No places in this collection.'))
              : ListView.builder(
                  itemCount: _places.length,
                  itemBuilder: (context, index) {
                    final place = _places[index];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://via.placeholder.com/150', // Replace with actual image URL
                          ),
                        ),
                        title: Text(place.name),
                        subtitle: Text(place.description),
                        onTap: () {
                          // Navigate to the place detail page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlaceDetailPage(placeId: place.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),  
    );
  }
}
