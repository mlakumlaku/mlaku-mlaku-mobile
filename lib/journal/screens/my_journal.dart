import 'package:flutter/material.dart';
import 'package:mlaku_mlaku/widgets/bottom_navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mlaku_mlaku/journal/screens/journal_entry_form.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mlaku_mlaku/models/journal_entry.dart';
import 'journal_home.dart';

class MyJournal extends StatefulWidget {
  @override
  _MyJournalState createState() => _MyJournalState();
}

class _MyJournalState extends State<MyJournal> {
  List<JournalEntry> _myJournals = [];

  @override
  void initState() {
    super.initState();
    _fetchMyJournals(); // Fetch user's journals on init
  }

  Future<void> _fetchMyJournals() async {
    try {
      final request = context.read<CookieRequest>();
      final response = await request.get('http://127.0.0.1:8000/get-user-journals/'); // Gunakan endpoint get_journals_json
      
      if (response is List) {
        setState(() {
          _myJournals = response.map((item) => JournalEntry.fromJson(item)).toList();
        });
      } else {
        print('Invalid response format: $response');
      }
    } catch (e) {
      print('Error fetching journals: $e');
    }
  }

  Future<void> _handleLike(int journalId) async {
    try {
      final request = context.read<CookieRequest>();
      
      // Menggunakan journal_id sebagai bagian dari URL
      final response = await request.post(
        "http://127.0.0.1:8000/like-journal-flutter/$journalId/",
        {},  // Empty map karena data dikirim via URL
      );

      print('Like response: $response'); // Debug print

      if (response['status'] == 'success') {
        await _fetchMyJournals(); // Refresh journals after liking
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Successfully updated like'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        throw Exception(response['message'] ?? 'Failed to like journal');
      }
      
    } catch (e) {
      print('Error liking journal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to like journal. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _onTabSelected(int index) {
    // Removed tab selection logic
  }

  void _navigateToCreateEntry() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalEntryFormPage(
          onUpdate: () => _fetchMyJournals(), // Pass callback
        ),
      ),
    );
  }

  String _getFullImageUrl(String imagePath) {
    // Handle empty path
    if (imagePath == null || imagePath.isEmpty) {
      print('Warning: Empty image path provided');
      return ''; // Or return a default image URL
    }
  
    // Already a full URL
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
  
    // Clean up path
    String cleanPath = imagePath.trim();
    
    // Remove leading slash if exists
    if (cleanPath.startsWith('/')) {
      cleanPath = cleanPath.substring(1);
    }
  
    // Construct full URL with media path
    try {
      return 'http://127.0.0.1:8000/$cleanPath';
    } catch (e) {
      print('Error constructing image URL: $e');
      return ''; // Or return default image URL
    }
  }

  Future<void> _deleteJournal(int journalId) async {
    try {
      final request = context.read<CookieRequest>();
      final response = await request.post(
        "http://127.0.0.1:8000/delete-journal-flutter/$journalId/",
        {},
      );

      if (response['status'] == 'success') {
        await _fetchMyJournals(); // Refresh after delete
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Journal deleted successfully')),
          );
        }
      } else {
        throw Exception(response['message'] ?? 'Failed to delete journal');
      }
    } catch (e) {
      print('Error deleting journal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete journal. Please try again.')),
      );
    }
  }

  void _navigateToEditEntry(JournalEntry journal) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalEntryFormPage(
          journalToEdit: journal,
          onUpdate: () => _fetchMyJournals(), // Pass callback
        ),
      ),
    );
  }

  Widget _buildJournalCard(JournalEntry journal) {
    final fields = journal.fields;
    final jakartaTimeZone = Duration(hours: 7); // Jakarta UTC+7
    final createdAtInJakarta = fields.createdAt.toUtc().add(jakartaTimeZone); // Konversi waktu ke Jakarta
    final formattedDate = DateFormat('MMM d, yyyy • h:mm a').format(createdAtInJakarta); // Format tanggal

    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              child: fields.image != null && fields.image.isNotEmpty
                ? Image.network(
                    _getFullImageUrl(fields.image),
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      return Icon(Icons.person); // Fallback icon
                    },
                  )
                : Icon(Icons.person), // Default icon
            ),
            title: Text(fields.authorUsername ?? 'Unknown User'),
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
                ],
              ),
            ),
          // Move the souvenir information here
          if (fields.souvenirName != null || fields.souvenirPrice != null) ...[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.card_giftcard, size: 16),
                  SizedBox(width: 4),
                  Text('Souvenir: ${fields.souvenirName ?? 'No Souvenir'}'),
                  SizedBox(width: 16),
                  Text('Price: ${fields.souvenirPrice ?? 'Unknown'}'),
                ],
              ),
            ),
          ],

          // Update the image section
          if (fields.image.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4, // 40% of screen height
                ),
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: 16 / 9, // Default aspect ratio if needed
                  child: Image.network(
                    _getFullImageUrl(fields.image),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      print('Image path: ${fields.image}');
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error),
                            Text('Failed to load image'),
                            Text(_getFullImageUrl(fields.image)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
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
                // Tambahkan tombol edit dan delete
                Spacer(),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _navigateToEditEntry(journal),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Tambahkan dialog konfirmasi
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete Journal'),
                          content: Text('Are you sure you want to delete this journal?'),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              child: Text('Delete'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _deleteJournal(journal.pk);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
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
        title: Text('Your Journal History'),
      ),
      body: Column(
        children: [
          // Journal List
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchMyJournals,
              child: ListView.builder(
                itemCount: _myJournals.length,
                itemBuilder: (context, index) {
                  return _buildJournalCard(_myJournals[index]);
                },
              ),
            ),
          ),
          // Button to go back to Journal Home
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true); // Kembali dan mengembalikan nilai true
              },
              child: Text('For You'),
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