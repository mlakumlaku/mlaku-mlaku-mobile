// import 'package:flutter/material.dart';
// import 'package:mlaku_mlaku/journal/screens/journal_home.dart';
// import '../../models/collections.dart';
// import 'collection_places_screen.dart';
// import '../../widgets/bottom_navbar.dart';
// import '../../services/collection_services.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';

// extension ListExtensions<T> on List<T> {
//   void addIf(bool condition, T value) {
//     if (condition) add(value);
//   }
// }

// class CollectionsScreen extends StatefulWidget {
//   final List<Collection> collections;
//   final CookieRequest request;

//   const CollectionsScreen({super.key, required this.collections, required this.request});

//   @override
//   State<CollectionsScreen> createState() => _CollectionsScreenState();
// }

// class _CollectionsScreenState extends State<CollectionsScreen> {
//   late List<Collection> collections;
//   String _sortOrder = "A-Z"; // Default sort order

//   @override
//   void initState() {
//     super.initState();
//     collections = widget.collections;
//   }

//   Future<void> _createNewCollection(BuildContext context) async {
//     TextEditingController collectionNameController = TextEditingController();

//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Create New Collection'),
//           content: TextField(
//             controller: collectionNameController,
//             decoration: const InputDecoration(hintText: 'Enter collection name'),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 String name = collectionNameController.text.trim();
//                 if (name.isNotEmpty) {
//                   try {
//                     await CollectionService().createCollection(widget.request, name);
//                     final updatedCollections =
//                         await CollectionService().fetchCollections(widget.request);
//                     setState(() {
//                       collections = updatedCollections;
//                     });
//                     Navigator.of(context).pop();
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Failed to create collection: $e')),
//                     );
//                   }
//                 }
//               },
//               child: const Text('Create'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _sortCollections(String order) {
//     setState(() {
//       if (order == "A-Z") {
//         collections.sort((a, b) => a.name.compareTo(b.name));
//       } else if (order == "Z-A") {
//         collections.sort((a, b) => b.name.compareTo(a.name));
//       }
//       _sortOrder = order;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Collections',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color(0xFF282A3A),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => _createNewCollection(context),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF4A90E2),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text(
//                     'Create',
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 DropdownButton<String>(
//                   value: _sortOrder,
//                   style: const TextStyle(color: Colors.white), // Atur warna tulisan menjadi putih
//                   dropdownColor: const Color.fromARGB(255, 63, 122, 86),
//                   onChanged: (String? newValue) {
//                     if (newValue != null) {
//                       _sortCollections(newValue);
//                     }
//                   },
//                   items: <String>['A-Z', 'Z-A']
//                       .map((value) => DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(
//                               'Sort $value',
//                               style: const TextStyle(color: Colors.black),
//                             ),
//                           ))
//                       .toList(),
//                   icon: const Icon(Icons.sort),
//                   underline: Container(
//                     height: 2,
//                     color: const Color(0xFF4A90E2),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 8, // Lebih kecil dari sebelumnya
//                   mainAxisSpacing: 8,  // Lebih kecil dari sebelumnya
//                   childAspectRatio: 0.9, // Menyesuaikan proporsi card
//                 ),
//                 itemCount: collections.length,
//                 itemBuilder: (context, index) {
//                   final collection = collections[index];
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CollectionPlacesScreen(
//                             collectionId: collection.id,
//                             collectionName: collection.name,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Card(
//                       margin: const EdgeInsets.all(6.0), // Margin lebih kecil
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12), // Ukuran border tetap
//                       ),
//                       child: Column(
//                         children: [
//                           Container(
//                             height: 80, // Lebih kecil dari sebelumnya
//                             decoration: BoxDecoration(
//                               borderRadius: const BorderRadius.vertical(
//                                 top: Radius.circular(12),
//                               ),
//                               image: DecorationImage(
//                                 image: NetworkImage(
//                                   collection.getCollectionImageUrl() ??
//                                       'https://via.placeholder.com/150',
//                                 ),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0), // Padding lebih kecil
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   collection.name,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14, // Ukuran font lebih kecil
//                                   ),
//                                 ),
//                                 const SizedBox(height: 2),
//                                 Text(
//                                   'Created ${collection.createdAt}',
//                                   style: const TextStyle(
//                                     fontSize: 11, // Ukuran font lebih kecil
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Wrap(
//                                   spacing: 4,
//                                   runSpacing: 4,
//                                   children: collection.places.take(3).map((place) {
//                                     return Chip(
//                                       label: Text(
//                                         place.name,
//                                         style: const TextStyle(
//                                           fontSize: 11, // Ukuran font chip lebih kecil
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                     );
//                                   }).toList()
//                                     ..addIf(
//                                       collection.places.length > 3,
//                                       Chip(
//                                         label: Text(
//                                           '+${collection.places.length - 3} more',
//                                           style: const TextStyle(
//                                             fontSize: 11, // Ukuran font chip lebih kecil
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//           ],
//         ),
//       ),
//       backgroundColor: const Color(0xFF282A3A),
//       bottomNavigationBar: BottomNavBar(
//         onTap: (index) {
//           if (index == 2) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => JournalHome()),
//             );
//           } else if (index == 0) {
//             Navigator.popUntil(context, (route) => route.isFirst);
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Page not available')),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
