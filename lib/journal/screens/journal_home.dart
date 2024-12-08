import 'package:flutter/material.dart';
import 'package:mlaku_mlaku/widgets/bottom_navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mlaku_mlaku/journal/screens/journal_entry_form.dart';
import 'dart:convert';
import 'package:provider/provider.dart'; // This is necessary for using context.read
import 'package:intl/intl.dart'; // Add this import
import 'package:mlaku_mlaku/models/journal_entry.dart';

class JournalHome extends StatefulWidget {
  @override
  _JournalHomeState createState() => _JournalHomeState();
}

class _JournalHomeState extends State<JournalHome> {
  List<JournalEntry> _journals = [];
  int _selectedIndex = 0; // Track the selected tab

  @override
  void initState() {
    super.initState();
    _fetchJournals(); // Fetch journals when the widget is initialized
  }

  Future<void> _fetchJournals() async {
    final request = context.read<CookieRequest>();
    final response = await request.get('http://127.0.0.1:8000/json/');
    setState(() {
      _journals = journalEntryFromJson(jsonEncode(response));
    });
  }

  Future<void> _handleLike(int journalId) async {
    try {
      final request = context.read<CookieRequest>();
      
      // Updated URL to match Django URL pattern
      final response = await request.post(
        "http://127.0.0.1:8000/like/$journalId/",
        {},
      );

      print('Like response: $response'); // Debug print

      if (response != null && (response['liked'] != null || response['error'] != null)) {
        await _fetchJournals(); // Refresh journals to update likes
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print('Error liking journal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to like journal. Please try again.')),
      );
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToCreateEntry() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JournalEntryFormPage()),
    );

    if (result != null) {
      result(); // Call the refresh method
    }
  }

  String _getFullImageUrl(String imagePath) {
    if (imagePath.isEmpty) return '';
    if (imagePath.startsWith('http')) return imagePath;
    // Ensure there's a leading slash
    if (!imagePath.startsWith('/')) {
      imagePath = '/' + imagePath;
    }
    return 'http://127.0.0.1:8000$imagePath';
  }

  Widget _buildJournalCard(JournalEntry journal) {
    final fields = journal.fields;
    final formattedDate = DateFormat('MMM d, yyyy • h:mm a').format(fields.createdAt);

    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(fields.authorUsername),
            subtitle: Text(formattedDate),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fields.title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(fields.content),
              ],
            ),
          ),

          if (fields.placeName != null && fields.placeName!.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.location_on, size: 16),
                  SizedBox(width: 4),
                  Text(fields.placeName!),
                  if (fields.souvenir != null) ...[
                    SizedBox(width: 16),
                    Icon(Icons.card_giftcard, size: 16),
                    SizedBox(width: 4),
                    Text('Souvenir ID: ${fields.souvenir}'),
                  ],
                ],
              ),
            ),

          // Update the image section
          if (fields.image.isNotEmpty)
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              height: 200,
              width: double.infinity,
              child: Image.network(
                _getFullImageUrl(fields.image),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: $error'); // Add debug print
                  print('Image path: ${fields.image}'); // Debug print the image path
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error),
                        Text('Failed to load image'),
                        Text(_getFullImageUrl(fields.image)), // Show the full URL for debugging
                      ],
                    ),
                  );
                },
              ),
            ),

          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () => _handleLike(journal.pk),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          fields.likes.isNotEmpty ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: Colors.red,
                        ),
                        SizedBox(width: 4),
                        Text('${fields.likes.length}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journals'),
      ),
      body: Column(
        children: [
          // Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _onTabSelected(0),
                child: Text('For You'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to My Journal History
                },
                child: Text('My Journal'),
              ),
              ElevatedButton(
                onPressed: _navigateToCreateEntry,
                child: Text('Publish'),
              ),
            ],
          ),
          // Journal List
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchJournals,
              child: ListView.builder(
                itemCount: _journals.length,
                itemBuilder: (context, index) {
                  return _buildJournalCard(_journals[index]);
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JournalHome()),
            );
          }
        },
      ),
    );
  }
}
