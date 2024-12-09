import 'package:flutter/material.dart';
import 'package:mlaku_mlaku/widgets/bottom_navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mlaku_mlaku/journal/screens/journal_entry_form.dart';
import 'dart:convert';
import 'package:provider/provider.dart'; // This is necessary for using context.read

class JournalHome extends StatefulWidget {
  @override
  _JournalHomeState createState() => _JournalHomeState();
}

class _JournalHomeState extends State<JournalHome> {
  List<dynamic> _journals = [];
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
      _journals = response; // Assuming response is a list of journals
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
                  // Implement your logic here
                },
                child: Text('My Journal'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JournalEntryFormPage()),
                  );
                },
                child: Text('Publish'),
              ),
            ],
          ),
          // Display Journals
          Expanded(
            child: ListView.builder(
              itemCount: _journals.length,
              itemBuilder: (context, index) {
                final journal = _journals[index];
                return ListTile(
                  title: Text(journal['fields']['title']),
                  subtitle: Text(journal['fields']['content']),
                  onTap: () {
                    // Navigate to journal detail page if needed
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        onTap: (index) {
          if (index == 2) {
            // Navigasi ke halaman jurnal home
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JournalHome()), // Ganti dengan halaman yang sesuai
            );
          }
          // Tambahkan aksi untuk item lain jika diperlukan
        },
      ),
    );
  }
}
