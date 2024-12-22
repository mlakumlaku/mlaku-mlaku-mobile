import 'package:flutter/material.dart';
import 'package:mlaku_mlaku/models/journal_entry.dart';
import 'package:intl/intl.dart'; // Add this import

class JournalDetailPage extends StatelessWidget {
  final JournalEntry journal;

  JournalDetailPage({required this.journal});

  @override
  Widget build(BuildContext context) {
    final fields = journal.fields;

    return Scaffold(
      appBar: AppBar(
        title: Text(fields.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fields.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'By: ${fields.authorUsername ?? 'Unknown User'}',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 8),
            Text(
              'Location: ${fields.placeName ?? 'No Location'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${DateFormat('MMM d, yyyy • h:mm a').format(fields.createdAt.toUtc().add(Duration(hours: 7)))}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              fields.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            if (fields.image != null && fields.image.isNotEmpty)
              Image.network(
                _getFullImageUrl(fields.image),
                fit: BoxFit.cover,
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
              child: Text('Back to For You Page'),
            ),
          ],
        ),
      ),
    );
  }

  String _getFullImageUrl(String imagePath) {
    if (imagePath.isEmpty) return '';
    return 'https://malika-atha31-mlakumlaku.pbp.cs.ui.ac.id';
  }
} 