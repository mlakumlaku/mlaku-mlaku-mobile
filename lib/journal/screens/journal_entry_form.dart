import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mlaku_mlaku/journal/screens/journal_entry_form.dart';  // Add this import
import '../../models/journal_entry.dart';  // Update this import line

class JournalEntryFormPage extends StatefulWidget {
  final JournalEntry? journalToEdit;
  final Function? onUpdate;

  const JournalEntryFormPage({
    Key? key,
    this.journalToEdit,
    this.onUpdate,
  }) : super(key: key);

  @override
  _JournalEntryFormPageState createState() => _JournalEntryFormPageState();
}

class _JournalEntryFormPageState extends State<JournalEntryFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String _placeName = "";
  String? _souvenirId;
  List<dynamic> _souvenirs = [];
  List<dynamic> _places = [];
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.journalToEdit?.fields.title ?? '');
    _contentController = TextEditingController(text: widget.journalToEdit?.fields.content ?? '');
    
    if (widget.journalToEdit != null) {
      _placeName = widget.journalToEdit!.fields.placeName ?? '';
      _souvenirId = widget.journalToEdit!.fields.souvenir?.toString();
    }
    
    _loadPlaces();
    if (_placeName.isNotEmpty) {
      _fetchSouvenirs(_placeName);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _loadPlaces() async {
    try {
      final places = await _fetchPlaces();
      setState(() {
        _places = places;
      });
      print('Loaded places: $_places'); // Print the loaded places
    } catch (e) {
      print('Error loading places: $e'); // Debug print statement
    }
  }

  Future<List<dynamic>> _fetchPlaces() async {
    try {
      final request = context.read<CookieRequest>();
      final response = await request.get("http://127.0.0.1:8000/get-places/");
      print('Raw response: $response');
      
      if (response != null) {
        final places = response['places'];
        print('Fetched places: $places');
        return places ?? [];
      }
      return [];
    } catch (e) {
      print('Exception during fetch: $e');
      return [];
    }
  }

  Future<void> _fetchSouvenirs(String placeName) async {
    final request = context.read<CookieRequest>();
    final response = await request.get('http://127.0.0.1:8000/get-souvenirs/?place_name=$placeName');
    print(response); // Check if souvenirs are fetched correctly
    setState(() {
      _souvenirs = response['souvenirs'] ?? []; // Access the 'souvenirs' key from response
      _souvenirId = null; // Reset souvenir selection
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  String _getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    return 'http://127.0.0.1:8000$imagePath';
  }

  Widget _buildImagePreview() {
    if (_imageBytes != null) {
      return Image.memory(
        _imageBytes!,
        height: 200,
        fit: BoxFit.cover,
      );
    } else if (widget.journalToEdit?.fields.image != null && 
               widget.journalToEdit!.fields.image.isNotEmpty) {
      return Image.network(
        _getFullImageUrl(widget.journalToEdit!.fields.image),
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error');
          return const Text('Failed to load image');
        },
      );
    }
    return const SizedBox.shrink();
  }

  Future<void> _updateJournal() async {
    try {
      final request = context.read<CookieRequest>();
      
      String? imageBase64;
      if (_imageBytes != null) {
        imageBase64 = base64Encode(_imageBytes!);
      }

      // Create the request data
      final requestData = jsonEncode({
        'title': _titleController.text,
        'content': _contentController.text,
        'place_name': _placeName,
        'souvenir': _souvenirId,
        'image': imageBase64,
      });

      final response = await request.postJson(
        "http://127.0.0.1:8000/edit-journal-flutter/${widget.journalToEdit!.pk}/",  // Endpoint untuk update
        requestData,
      );

      if (response != null) {
        if (widget.onUpdate != null) {
          widget.onUpdate!();
        }
        Navigator.pop(context);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Journal updated successfully!")),
          );
        }
      }
    } catch (e) {
      print('Error updating journal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.journalToEdit != null ? 'Edit Journal Entry' : 'Create Journal Entry'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(labelText: 'Content'),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter content';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Select Place'),
                  value: _placeName.isNotEmpty ? _placeName : null,
                  items: _places.map((place) {
                    return DropdownMenuItem<String>(
                      value: place,
                      child: Text(place),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _placeName = value!;
                      _fetchSouvenirs(_placeName);
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Select Souvenir'),
                  value: _souvenirId,
                  items: _souvenirs.map((souvenir) {
                    return DropdownMenuItem<String>(
                      value: souvenir['id'].toString(),
                      child: Text('${souvenir['name']} - Rp${souvenir['price']}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _souvenirId = value;
                    });
                  },
                ),
                // Image preview
                const SizedBox(height: 10),
                _buildImagePreview(),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_imageBytes != null || (widget.journalToEdit?.fields.image != null && 
                         widget.journalToEdit!.fields.image.isNotEmpty) 
                         ? 'Image selected' 
                         : 'No image selected'),
                    TextButton(
                      onPressed: _pickImage,
                      child: const Text('Pick Image'),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (widget.journalToEdit != null) {
                        await _updateJournal();
                      } else {
                        try {
                          final request = context.read<CookieRequest>();
                          
                          String? imageBase64;
                          if (_imageBytes != null) {
                            imageBase64 = base64Encode(_imageBytes!);
                          }

                          final requestData = jsonEncode({
                            'title': _titleController.text,
                            'content': _contentController.text,
                            'place_name': _placeName,
                            'souvenir': _souvenirId,
                            'image': imageBase64,
                          });

                          final response = await request.postJson(
                            "http://127.0.0.1:8000/create-journal-flutter/",
                            requestData,
                          );

                          if (response != null) {
                            if (widget.onUpdate != null) {
                              widget.onUpdate!();
                            }
                            Navigator.pop(context);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Journal created!")),
                              );
                            }
                          }
                        } catch (e) {
                          print('Error: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: ${e.toString()}")),
                          );
                        }
                      }
                    }
                  },
                  child: Text(widget.journalToEdit != null ? 'Update' : 'Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}