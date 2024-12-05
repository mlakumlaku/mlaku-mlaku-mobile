import 'package:flutter/material.dart';
import 'package:mlaku_mlaku/widgets/bottom_navbar.dart'; // Ganti dengan path yang sesuai
import 'package:mlaku_mlaku/journal/screens/journal_entry_form.dart'; // Tambahkan import ini

class JournalHome extends StatefulWidget {
  @override
  _JournalHomeState createState() => _JournalHomeState();
}

class _JournalHomeState extends State<JournalHome> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MlakuMlaku'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Aksi untuk ikon akun
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Bagian untuk tombol "For You", "My Journal", dan "Publish"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(onPressed: () {}, child: Text('For You')),
              MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'My Journal',
                    style: TextStyle(color: _isHovered ? Colors.red : null),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigasi ke halaman JournalEntryFormPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JournalEntryFormPage()),
                  );
                },
                child: Text('Publish'),
              ),
            ],
          ),
          // Daftar jurnal
          Expanded(
            child: ListView.builder(
              itemCount: 0, // Ganti dengan jumlah jurnal yang sesuai
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Judul Jurnal'), // Ganti dengan judul jurnal yang sesuai
                  subtitle: Text('by penulis'), // Ganti dengan nama penulis
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
