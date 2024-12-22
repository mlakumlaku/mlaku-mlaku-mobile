// import 'package:flutter/material.dart';
// import 'package:mlaku_mlaku/collections/screens/collection_detail_page.dart';
// import 'package:provider/provider.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:mlaku_mlaku/services/collection_services.dart';
// import 'package:mlaku_mlaku/models/collections.dart';

// class CollectionsPage extends StatefulWidget {
//   const CollectionsPage({Key? key}) : super(key: key);

//   @override
//   State<CollectionsPage> createState() => _CollectionsPageState();
// }

// class _CollectionsPageState extends State<CollectionsPage> {
//   late CollectionService _collectionService;
//   late Future<List<Collection>> _collectionsFuture;
//   final _nameController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     final request = context.read<CookieRequest>();
//     _collectionService = CollectionService(request);
//     _refreshCollections();
//   }

//   void _refreshCollections() {
//     setState(() {
//       _collectionsFuture = _collectionService.getCollections();
//     });
//   }

//   Future<void> _showCreateCollectionDialog() async {
//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Create Collection'),
//         content: TextField(
//           controller: _nameController,
//           decoration: const InputDecoration(
//             labelText: 'Collection Name',
//             hintText: 'Enter a name for your collection'
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (_nameController.text.isNotEmpty) {
//                 try {
//                   await _collectionService.createCollection(_nameController.text);
//                   if (!mounted) return;
//                   Navigator.pop(context);
//                   _nameController.clear();
//                   _refreshCollections();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Collection created successfully')),
//                   );
//                 } catch (e) {
//                   if (!mounted) return;
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Error: $e')),
//                   );
//                 }
//               }
//             },
//             child: const Text('Create'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _confirmDelete(Collection collection) async {
//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Collection'),
//         content: Text('Are you sure you want to delete "${collection.name}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () async {
//               try {
//                 await _collectionService.deleteCollection(collection.id);
//                 if (!mounted) return;
//                 Navigator.pop(context);
//                 _refreshCollections();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Collection deleted successfully')),
//                 );
//               } catch (e) {
//                 if (!mounted) return;
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Error: $e')),
//                 );
//               }
//             },
//             child: const Text('Delete', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isLoggedIn = context.watch<CookieRequest>().loggedIn;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Collections'),
//       ),
//       body: !isLoggedIn
//           ? const Center(child: Text('Please log in to view your collections'))
//           : FutureBuilder<List<Collection>>(
//               future: _collectionsFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }

//                 final collections = snapshot.data!;
//                 if (collections.isEmpty) {
//                   return const Center(
//                     child: Text('No collections yet. Create one to get started!'),
//                   );
//                 }

//                 return ListView.builder(
//                   itemCount: collections.length,
//                   itemBuilder: (context, index) {
//                     final collection = collections[index];
//                     return Card(
//                       margin: const EdgeInsets.all(8.0),
//                       child: ListTile(
//                         title: Text(collection.name),
//                         subtitle: Text('Created: ${collection.createdAt}'),
//                         trailing: IconButton(
//                           icon: const Icon(Icons.delete),
//                           onPressed: () => _confirmDelete(collection),
//                         ),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => CollectionDetailPage(collection: collection),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//       floatingActionButton: isLoggedIn
//           ? FloatingActionButton(
//               onPressed: _showCreateCollectionDialog,
//               child: const Icon(Icons.add),
//             )
//           : null,
//     );
//   }

import 'package:flutter/material.dart';
import 'package:mlaku_mlaku/collections/screens/collection_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mlaku_mlaku/services/collection_services.dart';
import 'package:mlaku_mlaku/models/collections.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({Key? key}) : super(key: key);

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  late CollectionService _collectionService;
  late Future<List<Collection>> _collectionsFuture;
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    _collectionService = CollectionService(request);
    _refreshCollections();
  }

  void _refreshCollections() {
    setState(() {
      _collectionsFuture = _collectionService.getCollections();
    });
  }

  Future<void> _showCreateCollectionDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Collection'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
              labelText: 'Collection Name',
              hintText: 'Enter a name for your collection'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_nameController.text.isNotEmpty) {
                try {
                  await _collectionService
                      .createCollection(_nameController.text);
                  if (!mounted) return;
                  Navigator.pop(context);
                  _nameController.clear();
                  _refreshCollections();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Collection created successfully')),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(Collection collection) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Collection'),
        content: Text('Are you sure you want to delete "${collection.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await _collectionService.deleteCollection(collection.id);
                if (!mounted) return;
                Navigator.pop(context);
                _refreshCollections();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Collection deleted successfully')),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<CookieRequest>().loggedIn;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Collections'),
      ),
      body: !isLoggedIn
          ? const Center(child: Text('Please log in to view your collections'))
          : FutureBuilder<List<Collection>>(
              future: _collectionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final collections = snapshot.data!;
                if (collections.isEmpty) {
                  return const Center(
                    child:
                        Text('No collections yet. Create one to get started!'),
                  );
                }

                return ListView.builder(
                  itemCount: collections.length,
                  itemBuilder: (context, index) {
                    final collection = collections[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(collection.name),
                        subtitle: Text('Created: ${collection.createdAt}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _confirmDelete(collection),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CollectionDetailPage(collection: collection),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: isLoggedIn
          ? FloatingActionButton(
              onPressed: _showCreateCollectionDialog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
