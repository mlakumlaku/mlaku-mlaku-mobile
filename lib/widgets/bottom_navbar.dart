import 'package:flutter/material.dart';
import 'package:mlaku_mlaku/journal/screens/journal_home.dart'; // Ganti dengan path yang sesuai

class BottomNavBar extends StatefulWidget {
  final Function(int) onTap;

  BottomNavBar({required this.onTap});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigate to Home
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (index == 2) {
      // Navigate to Journals
      // Ganti dengan halaman yang sesuai
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => JournalHome()), // Ganti dengan halaman yang sesuai
      );
    } else {
      // Show snackbar for other items
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Page belum tersedia')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Colors.black),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list, color: Colors.black),
          label: 'Itinerary',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book, color: Colors.black),
          label: 'Journal',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.collections, color: Colors.black),
          label: 'Collection',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      backgroundColor: Colors.redAccent,
      selectedItemColor: Colors.redAccent,
      unselectedItemColor: Colors.black,
      // Add hover effects
      mouseCursor: SystemMouseCursors.click,
    );
  }
}
