// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:mlaku_mlaku/models/journal_entry.dart';

// class JournalEditFormPage extends StatefulWidget {
//   final JournalEntry journal;

//   const JournalEditFormPage({super.key, required this.journal});

//   @override
//   State<JournalEditFormPage> createState() => _JournalEditFormPageState();
// }

// class _JournalEditFormPageState extends State<JournalEditFormPage> {
//   final _formKey = GlobalKey<FormState>();
//   late String _title;
//   late String _content;
//   late String _placeName;
//   String? _souvenirId;
//   List<dynamic> _souvenirs = [];
//   List<dynamic> _places = [];
//   Uint8List? _imageBytes;

//   @override
//   void initState() {
//     super.initState();
//     _loadInitialData();
//   }

//   void _loadInitialData() {
//     _title = widget.journal.fields.title;
//     _content = widget.journal.fields.content;
//     _placeName = widget.journal.fields.placeName ?? "";
//     _souvenirId = widget.journal.fields.souvenir?.toString();
//     _loadPlaces().then((_) {
//       if (_placeName.isNotEmpty) {
//         _fetchSouvenirs(_placeName);
//       }
//     });
//   }

//   Future<void> _loadPlaces() async {
//     try {
//       final places = await _fetchPlaces();
//       setState(() {
//         _places = places;
//       });
//     } catch (e) {
//       print('Error loading places: $e');
//     }
//   }

//   Future<List<dynamic>> _fetchPlaces() async {
//     try {
//       final request = context.read<CookieRequest>();
//       final response = await request.get("http://127.0.0.1:8000/get-places/");
//       if (response != null) {
//         return response['places'] ?? [];
//       }
//       return [];
//     } catch (e) {
//       print('Exception during fetch: $e');
//       return [];
//     }
//   }

//   Future<void> _fetchSouvenirs(String placeName) async {
//     final request = context.read<CookieRequest>();
//     final response = await request.get('http://127.0.0.1:8000/get-souvenirs/?place_name=$placeName');
//     setState(() {
//       _souvenirs = response['souvenirs'] ?? [];
//     });
//   }

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       final bytes = await pickedFile.readAsBytes();
//       setState(() {
//         _imageBytes = bytes;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Journal Entry'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextFormField(
//                   initialValue: _title,
//                   decoration: const InputDecoration(labelText: 'Title'),
//                   onChanged: (value) => _title = value,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a title';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   initialValue: _content,
//                   decoration: const InputDecoration(labelText: 'Content'),
//                   onChanged: (value) => _content = value,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter content';
//                     }
//                     return null;
//                   },
//                 ),
//                 DropdownButtonFormField<String>(
//                   value: _places.contains(_placeName) ? _placeName : null,
//                   decoration: const InputDecoration(labelText: 'Select Place'),
//                   items: _places.map((place) {
//                     return DropdownMenuItem<String>(
//                       value: place,
//                       child: Text(place.toString()),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     if (value != null) {
//                       setState(() {
//                         _placeName = value;
//                         _souvenirId = null;
//                         _fetchSouvenirs(_placeName);
//                       });
//                     }
//                   },
//                 ),
//                 DropdownButtonFormField<String>(
//                   decoration: const InputDecoration(labelText: 'Select Souvenir'),
//                   value: _souvenirs.any((s) => s['id'].toString() == _souvenirId) ? _souvenirId : null,
//                   items: _souvenirs.map((souvenir) {
//                     return DropdownMenuItem<String>(
//                       value: souvenir['id'].toString(),
//                       child: Text(souvenir['name'].toString()),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _souvenirId = value;
//                     });
//                   },
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(_imageBytes == null ? 'No new image selected' : 'New image selected'),
//                     TextButton(
//                       onPressed: _pickImage,
//                       child: const Text('Pick Image'),
//                     ),
//                   ],
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     if (_formKey.currentState!.validate()) {
//                       try {
//                         final request = context.read<CookieRequest>();
                        
//                         String? imageBase64;
//                         if (_imageBytes != null) {
//                           imageBase64 = base64Encode(_imageBytes!);
//                         }

//                         final requestData = jsonEncode({
//                           'title': _title,
//                           'content': _content,
//                           'place_name': _placeName,
//                           'souvenir': _souvenirId,
//                           'image': imageBase64,
//                         });

//                         final response = await request.postJson(
//                           "http://127.0.0.1:8000/edit/${widget.journal.pk}/",
//                           requestData,
//                         );

//                         if (response != null) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text("Journal entry updated successfully!")),
//                           );
//                           Navigator.pop(context, true);
//                         } else {
//                           throw Exception('Failed to update journal');
//                         }
//                       } catch (e) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text("Error: ${e.toString()}")),
//                         );
//                       }
//                     }
//                   },
//                   child: const Text("Update"),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// } 