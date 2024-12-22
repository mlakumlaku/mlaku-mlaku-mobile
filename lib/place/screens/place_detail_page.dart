import 'package:flutter/material.dart';
import 'package:mlaku_mlaku/services/collection_services.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mlaku_mlaku/services/place_service.dart';
import 'package:mlaku_mlaku/models/place.dart';
import 'package:mlaku_mlaku/models/collections.dart';

class PlaceDetailPage extends StatefulWidget {
  final int placeId;

  const PlaceDetailPage({Key? key, required this.placeId}) : super(key: key);

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  late PlaceService _placeService;
  late CollectionService _collectionService;
  Future<Place>? _placeFuture;
  Future<List<Collection>>? _collectionsFuture;

  final _commentController = TextEditingController();
  int _rating = 0;
  List<int> _selectedCollections = [];

  @override
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false);
    _placeService = PlaceService(request);
    _collectionService = CollectionService();
    _loadPlaceDetail();
    _loadCollections();
  }

  void _loadPlaceDetail() {
    setState(() {
      _placeFuture = _placeService.fetchPlaceDetail(widget.placeId);
    });
  }

  void _loadCollections() {
    final request = Provider.of<CookieRequest>(context, listen: false);
    setState(() {
      _collectionsFuture = _collectionService.fetchCollections(request);
    });
  }

  Future<void> _showAddToCollectionDialog() async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    if (!request.loggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add to collections')),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add to Collections'),
          content: FutureBuilder<List<Collection>>(
            future: _collectionsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No collections available. Create one first!');
              }

              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: snapshot.data!.map((collection) {
                        return CheckboxListTile(
                          title: Text(collection.name),
                          value: _selectedCollections.contains(collection.id),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedCollections.add(collection.id);
                              } else {
                                _selectedCollections.remove(collection.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _selectedCollections.clear();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_selectedCollections.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select at least one collection')),
                  );
                  return;
                }
                
                try {
                  await _collectionService.addPlaceToCollections(
                    request,
                    widget.placeId,
                    _selectedCollections,
                  );
                  
                  if (mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Successfully added to collections!')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add to collections: $e')),
                    );
                  }
                }
                _selectedCollections.clear();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context);
    final isLoggedIn = request.loggedIn;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Detail'),
        actions: [
          if (isLoggedIn)
            IconButton(
              icon: const Icon(Icons.bookmark_add),
              onPressed: _showAddToCollectionDialog,
              tooltip: 'Add to Collection',
            ),
        ],
      ),
      body: FutureBuilder<Place>(
        future: _placeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Place not found.'));
          }

          final place = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(place.description),
                  const SizedBox(height: 16),
                  if (isLoggedIn) ...[
                    const Text('Your Comment:'),
                    TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Write your comment here...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Your Rating:'),
                        const SizedBox(width: 8),
                        Row(
                          children: List.generate(5, (index) => IconButton(
                            icon: Icon(
                              index < _rating ? Icons.star : Icons.star_border,
                            ),
                            onPressed: () {
                              setState(() {
                                _rating = index + 1;
                              });
                            },
                          )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Submit comment logic here
                      },
                      child: const Text('Submit Comment'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _showAddToCollectionDialog,
                      icon: const Icon(Icons.bookmark_add),
                      label: const Text('Add to Collection'),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
