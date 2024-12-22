import 'package:flutter/material.dart';
import 'package:mlaku_mlaku/services/place_service.dart';
import 'package:mlaku_mlaku/models/place.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class PlaceDetailScreen extends StatefulWidget {
  final int placeId;

  const PlaceDetailScreen({Key? key, required this.placeId}) : super(key: key);

  @override
  _PlaceDetailScreenState createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  late Future<Place> _placeFuture;
  late PlaceService _placeService;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    _placeService = PlaceService(request);
    _refreshPlace();
  }

  void _refreshPlace() {
    setState(() {
      _placeFuture = _placeService.getPlaceDetails(widget.placeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final isLoggedIn = request.loggedIn;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Details'),
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

          final place = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    Text(' ${place.averageRating.toStringAsFixed(1)}'),
                  ],
                ),
                const SizedBox(height: 16),
                Text(place.description),
                const SizedBox(height: 24),
                _buildSouvenirsList(place),
                const SizedBox(height: 24),
                _buildCommentsList(place),
              ],
            ),
          );
        },
      ),
      floatingActionButton: isLoggedIn
          ? FloatingActionButton(
              onPressed: () => _showAddCommentDialog(context),
              child: const Icon(Icons.add_comment),
            )
          : null,
    );
  }

  Widget _buildSouvenirsList(Place place) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Souvenirs',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: place.souvenirs.length,
          itemBuilder: (context, index) {
            final souvenir = place.souvenirs[index];
            return Card(
              child: ListTile(
                title: Text(souvenir.name),
                subtitle:
                    Text('Price: ${souvenir.price}, Stock: ${souvenir.stock}'),
                trailing: ElevatedButton(
                  onPressed: souvenir.stock > 0
                      ? () => _buySouvenir(souvenir.id)
                      : null,
                  child: const Text('Buy'),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCommentsList(Place place) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comments',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: place.comments.length,
          itemBuilder: (context, index) {
            final comment = place.comments[index];
            return Card(
              child: ListTile(
                title: Row(
                  children: [
                    Text(comment.username),
                    const Spacer(),
                    Text('${comment.rating}/5 '),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                  ],
                ),
                subtitle: Text(comment.content),
                trailing: context.read<CookieRequest>().loggedIn
                    ? PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditCommentDialog(context, comment);
                          } else if (value == 'delete') {
                            _showDeleteCommentDialog(context, comment.id);
                          }
                        },
                      )
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _showAddCommentDialog(BuildContext context) async {
    final textController = TextEditingController();
    int rating = 5;

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Comment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'Comment',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () => setState(() => rating = index + 1),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (textController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a comment')),
                  );
                  return;
                }

                try {
                  await _placeService.addComment(
                    widget.placeId,
                    textController.text,
                    rating,
                  );
                  if (!mounted) return;
                  Navigator.pop(context);
                  _refreshPlace(); // Refresh immediately after adding
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Comment added successfully')),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditCommentDialog(
      BuildContext context, Comment comment) async {
    final textController = TextEditingController(text: comment.content);
    int rating = comment.rating;

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Comment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'Comment',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () => setState(() => rating = index + 1),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (textController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a comment')),
                  );
                  return;
                }

                try {
                  print(comment.id);
                  print(textController.text);
                  print(rating);
                  await _placeService.editComment(
                    comment.id,
                    textController.text,
                    rating,
                  );
                  if (!mounted) return;
                  Navigator.pop(context);
                  _refreshPlace(); // Refresh immediately after editing
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Comment updated successfully')),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteCommentDialog(BuildContext context, int commentId) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              try {
                await _placeService.deleteComment(commentId);
                if (!mounted) return;
                Navigator.pop(context);
                _refreshPlace(); // Refresh immediately after deleting
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Comment deleted successfully')),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _buySouvenir(int souvenirId) async {
    try {
      await _placeService.buySouvenir(souvenirId);
      _refreshPlace(); // Refresh immediately after purchase
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Souvenir purchased successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
