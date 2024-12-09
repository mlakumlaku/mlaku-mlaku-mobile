// lib/screens/place_detail_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mlaku_mlaku/services/place_service.dart';
import 'package:mlaku_mlaku/models/place.dart';

class PlaceDetailPage extends StatefulWidget {
  final int placeId;

  const PlaceDetailPage({Key? key, required this.placeId}) : super(key: key);

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  late PlaceService _placeService;
  Future<Place>? _placeFuture;

  final _commentController = TextEditingController();
  int _rating = 0; // rating from 1 to 5

  @override
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false);
    _placeService = PlaceService(request);
    _loadPlaceDetail();
  }

  void _loadPlaceDetail() {
    setState(() {
      _placeFuture = _placeService.fetchPlaceDetail(widget.placeId);
    });
  }

  Future<void> _submitComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty || _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide both comment and rating.')),
      );
      return;
    }
    try {
      await _placeService.addComment(widget.placeId, content, _rating);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comment added successfully!')),
      );
      _commentController.clear();
      _rating = 0;
      _loadPlaceDetail(); // Refresh data after adding comment
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add comment: $e')),
      );
    }
  }

  Widget _buildRatingStars() {
    return Row(
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return IconButton(
          icon: Icon(
            starIndex <= _rating ? Icons.star : Icons.star_border,
            color: Colors.yellow[700],
          ),
          onPressed: () {
            setState(() {
              _rating = starIndex;
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context);
    final isLoggedIn = request.loggedIn;

    return Scaffold(
      appBar: AppBar(
        title: Text('Place Detail'),
      ),
      body: FutureBuilder<Place>(
        future: _placeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading place: ${snapshot.error}'));
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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text('Average Rating: ${place.averageRating}/5'),
                  SizedBox(height: 8),
                  Text(place.description),
                  SizedBox(height: 16),
                  Divider(),
                  Text('Comments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  if (place.comments.isEmpty)
                    Text('No comments yet. Be the first to comment!'),
                  for (var c in place.comments) ...[
                    ListTile(
                      title: Text(c.username),
                      subtitle: Text(c.content),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${c.rating}/5'),
                          Icon(Icons.star, color: Colors.yellow[700], size: 20),
                        ],
                      ),
                    ),
                    Divider(),
                  ],

                  SizedBox(height: 16),
                  Text('Souvenirs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  if (place.souvenirs.isEmpty)
                    Text('No souvenirs available.'),
                  for (var s in place.souvenirs) ...[
                    ListTile(
                      title: Text(s.name),
                      subtitle: Text('Price: ${s.price}, Stock: ${s.stock}'),
                    ),
                    Divider(),
                  ],

                  if (isLoggedIn) ...[
                    SizedBox(height: 16),
                    Text('Add a Comment', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Write your comment...',
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 8),
                    Text('Your Rating:'),
                    _buildRatingStars(),
                    ElevatedButton(
                      onPressed: _submitComment,
                      child: Text('Submit'),
                    ),
                  ] else ...[
                    SizedBox(height: 16),
                    Text('Please log in to add a comment.'),
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
