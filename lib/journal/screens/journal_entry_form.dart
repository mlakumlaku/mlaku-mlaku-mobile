import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mlaku_mlaku/models/journal_entry.dart'; // Import model
import 'dart:convert'; // Untuk mengurai JSON

class JournalEntryFormPage extends StatefulWidget {
  const JournalEntryFormPage({super.key});

  @override
  State<JournalEntryFormPage> createState() => _JournalEntryFormPageState();
}

class _JournalEntryFormPageState extends State<JournalEntryFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _content = "";
  String? _selectedPlace;
  String? _selectedSouvenir;
  String _image = ""; // Store image path if needed
  List<dynamic> _places = [];
  List<dynamic> _souvenirs = [];
  List<dynamic> _filteredSouvenirs = []; // Souvenirs filtered by selected place

  @override
  void initState() {
    super.initState();
    _loadData(); // Panggil fungsi untuk memuat data
  }

  Future<void> _loadData() async {
    final String response = await rootBundle.loadString('assets/DATASET.json');
    final data = await json.decode(response);
    setState(() {
      _places = data; // Simpan data tempat
      _souvenirs = data; // Simpan data souvenir
      _filteredSouvenirs = data; // Awalnya, semua souvenirs
    });
  }

  void _filterSouvenirs(String? selectedPlace) {
    if (selectedPlace == null) {
      setState(() {
        _filteredSouvenirs = _souvenirs; // Reset to all souvenirs if no place is selected
      });
      return;
    }

    setState(() {
      _filteredSouvenirs = _souvenirs.where((souvenir) {
        return souvenir['Place Name'] == selectedPlace; // Filter souvenirs by selected place
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Create a New Journal',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Title",
                    labelText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _title = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Title cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Content",
                    labelText: "Content",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _content = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Content cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              DropdownButton<String>(
                value: _selectedPlace,
                hint: Text('-- Select Place --'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPlace = newValue;
                    _filterSouvenirs(newValue); // Filter souvenirs based on selected place
                  });
                },
                items: _places.map<DropdownMenuItem<String>>((dynamic place) {
                  return DropdownMenuItem<String>(
                    value: place['Place Name'],
                    child: Text(place['Place Name']),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: _selectedSouvenir,
                hint: Text('-- Select Souvenir --'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSouvenir = newValue;
                  });
                },
                items: _filteredSouvenirs.map<DropdownMenuItem<String>>((dynamic souvenir) {
                  return DropdownMenuItem<String>(
                    value: souvenir['Product Name'],
                    child: Text(souvenir['Product Name']),
                  );
                }).toList(),
              ),
              // Widget untuk memilih gambar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // Logika untuk memilih gambar
                    // Anda bisa menggunakan image_picker package
                  },
                  child: Text('Select Image'),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Simpan data ke model
                        final newEntry = Welcome(
                          model: 'journal_entry',
                          pk: 0, // Atur sesuai kebutuhan
                          fields: Fields(
                            author: 1, // Ganti dengan ID penulis yang sesuai
                            title: _title,
                            content: _content,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                            image: _image,
                            souvenir: _selectedSouvenir != null ? int.parse(_selectedSouvenir!) : null,
                            placeName: _selectedPlace,
                            likes: [],
                          ),
                        );

                        // Tampilkan dialog konfirmasi
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Journal Entry Saved'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Title: $_title'),
                                    Text('Content: $_content'),
                                    Text('Place: $_selectedPlace'),
                                    Text('Souvenir: $_selectedSouvenir'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _formKey.currentState!.reset();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}