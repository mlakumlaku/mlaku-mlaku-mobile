import 'package:flutter/material.dart';
import 'package:mlaku_mlaku/widgets/bottom_navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mlaku_mlaku/journal/screens/journal_entry_form.dart';
import 'dart:convert';
import 'package:provider/provider.dart'; // This is necessary for using context.read
import 'package:intl/intl.dart'; // Add this import
import 'package:mlaku_mlaku/models/journal_entry.dart';
import 'package:mlaku_mlaku/journal/screens/my_journal.dart';
import 'package:intl/intl.dart';
import 'package:mlaku_mlaku/journal/screens/journal_detail.dart';
import 'package:mlaku_mlaku/screens/login.dart';
import 'package:flutter/foundation.dart';

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
    final response = await request.get('https://nur-khoirunnisa-mlakumlaku2.pbp.cs.ui.ac.id/get-journals/');
    setState(() {
      _journals = journalEntryFromJson(jsonEncode(response));
    });
  }


  Future<void> _handleLike(int journalId) async {
    try {
      final request = context.read<CustomCookieRequest>();

      final response = await request.post(
        "https://nur-khoirunnisa-mlakumlaku2.pbp.cs.ui.ac.id/like-journal-flutter/$journalId/",
        {},  // Empty map karena data dikirim via URL
      );

      print('Like response: $response'); // Debug print

      if (response['status'] == 'success') {
        await _fetchJournals();
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
      print('Error liking journal: $e'); // Now action is defined
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to like journal. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToCreateEntry() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalEntryFormPage(
          onUpdate: () => _fetchJournals(), // Pass callback for create
        ),
      ),
    );
  }

  void _navigateToEditEntry(JournalEntry journal) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalEntryFormPage(
          journalToEdit: journal,
          onUpdate: () => _fetchJournals(), // Pass callback
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
      return 'https://nur-khoirunnisa-mlakumlaku2.pbp.cs.ui.ac.id/$cleanPath';
    } catch (e) {
      print('Error constructing image URL: $e');
      return ''; // Or return default image URL
    }
  }

  Widget _buildJournalCard(JournalEntry journal) {
    final fields = journal.fields;
    final currentUserId = context.read<CustomCookieRequest>().userId; // Get current user ID
    final isLiked = fields.likes.contains(currentUserId); // Check if the current user has liked the journal
    final jakartaTimeZone = Duration(hours: 7); // Jakarta UTC+7
    final createdAtInJakarta = fields.createdAt.toUtc().add(jakartaTimeZone);
    final formattedDate = DateFormat('MMM d, yyyy • h:mm a').format(createdAtInJakarta);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JournalDetailPage(journal: journal), // Navigate to detail page
          ),
        );
      },
      child: Card(
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
                  ],
                ),
              ),
            // Move the souvenir information here
            if (fields.souvenir != null) ...[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.card_giftcard, size: 16),
                    SizedBox(width: 4),
                    Text('Souvenir: ${fields.souvenirName}'),
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
                            color: Colors.red, // Set color based on like status
                          ),
                          SizedBox(width: 4),
                          Text('${fields.likes.length}'), // Display the like count
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMyJournal() async {
    final shouldRefresh = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => MyJournal()),
    );

    if (shouldRefresh == true) {
      await _fetchJournals(); // Refresh jika ada perubahan
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<CustomCookieRequest>(); // Get current user object
    final userName = currentUser.userName; // Access the userName

    return Scaffold(
      appBar: AppBar(
        title: Text('Journal Home'),
      ),
      body: Column(
        children: [
          // User Info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Logged in as: $userName', // Display current user's name
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          // Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _onTabSelected(0),
                child: Text('For You'),
              ),
              ElevatedButton(
                onPressed: _navigateToMyJournal,
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
        onTap: (index) async {
          if (index == 2) {
            final shouldRefresh = await Navigator.push<bool>(
              context,
              MaterialPageRoute(builder: (context) => JournalHome()),
            );
            
            if (shouldRefresh == true) {
              await _fetchJournals(); // Refresh when returning from MyJournal
            }
          }
        },
      ),
    );
  }
}