// // lib/screens/place_detail_page.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:mlaku_mlaku/services/place_service.dart';
// import 'package:mlaku_mlaku/models/place.dart';

// class PlaceDetailPage extends StatefulWidget {
//   final int placeId;

//   const PlaceDetailPage({Key? key, required this.placeId}) : super(key: key);

//   @override
//   State<PlaceDetailPage> createState() => _PlaceDetailPageState();
// }

// class _PlaceDetailPageState extends State<PlaceDetailPage> {
//   late PlaceService _placeService;
//   Future<Place>? _placeFuture;

//   final _commentController = TextEditingController();
//   int _rating = 0; // rating from 1 to 5

//   @override
//   void initState() {
//     super.initState();
//     // Get the request object
//     final request = Provider.of<CookieRequest>(context, listen: false);

//     // Print whether we're logged in. This should print true if the login was successful.
//     print("Are we logged in?: ${request.loggedIn}");

//     // Ensure the domain here matches the domain you used for login.
//     // If you used http://127.0.0.1:8000 for login, do the same for your PlaceService URLs.
//     // Check place_service.dart to ensure you're using `http://127.0.0.1:8000` and not `127.0.0.1`.

//     _placeService = PlaceService(request);
//     _loadPlaceDetail();
//   }

//   void _loadPlaceDetail() {
//     setState(() {
//       _placeFuture = _placeService.fetchPlaceDetail(widget.placeId);
//     });
//   }

//   Future<void> _submitComment() async {
//     final content = _commentController.text.trim();
//     if (content.isEmpty || _rating == 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please provide both comment and rating.')),
//       );
//       return;
//     }

//     // Before calling addComment, we can again check if logged in
//     final request = Provider.of<CookieRequest>(context, listen: false);
//     if (!request.loggedIn) {
//       // If not logged in, show a message or redirect
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('You are not logged in. Please log in first.')),
//       );
//       return;
//     }

//     try {
//       await _placeService.addComment(widget.placeId, content, _rating);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Comment added successfully!')),
//       );
//       _commentController.clear();
//       _rating = 0;
//       _loadPlaceDetail(); // Refresh data after adding comment
//     } catch (e) {
//       // Print the full error and check if it’s HTML or JSON
//       print("Full error response: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to add comment: $e')),
//       );
//     }
//   }

//   Widget _buildRatingStars() {
//     return Row(
//       children: List.generate(5, (index) {
//         final starIndex = index + 1;
//         return IconButton(
//           icon: Icon(
//             starIndex <= _rating ? Icons.star : Icons.star_border,
//             color: Colors.yellow[700],
//           ),
//           onPressed: () {
//             setState(() {
//               _rating = starIndex;
//             });
//           },
//         );
//       }),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final request = Provider.of<CookieRequest>(context);
//     final isLoggedIn = request.loggedIn;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Place Detail'),
//       ),
//       body: FutureBuilder<Place>(
//         future: _placeFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error loading place: ${snapshot.error}'));
//           }

//           final place = snapshot.data!;
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     place.name,
//                     style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   Text('Average Rating: ${place.averageRating}/5'),
//                   const SizedBox(height: 8),
//                   Text(place.description),
//                   const SizedBox(height: 16),
//                   const Divider(),
//                   const Text('Comments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   if (place.comments.isEmpty)
//                     const Text('No comments yet. Be the first to comment!'),
//                   for (var c in place.comments) ...[
//                     ListTile(
//                       title: Text(c.username),
//                       subtitle: Text(c.content),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text('${c.rating}/5'),
//                           Icon(Icons.star, color: Colors.yellow[700], size: 20),
//                         ],
//                       ),
//                     ),
//                     const Divider(),
//                   ],

//                   const SizedBox(height: 16),
//                   const Text('Souvenirs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   if (place.souvenirs.isEmpty)
//                     const Text('No souvenirs available.'),
//                   for (var s in place.souvenirs) ...[
//                     ListTile(
//                       title: Text(s.name),
//                       subtitle: Text('Price: ${s.price}, Stock: ${s.stock}'),
//                     ),
//                     const Divider(),
//                   ],

//                   if (isLoggedIn) ...[
//                     const SizedBox(height: 16),
//                     const Text('Add a Comment', style: TextStyle(fontWeight: FontWeight.bold)),
//                     TextField(
//                       controller: _commentController,
//                       decoration: const InputDecoration(
//                         hintText: 'Write your comment...',
//                       ),
//                       maxLines: 3,
//                     ),
//                     const SizedBox(height: 8),
//                     const Text('Your Rating:'),
//                     _buildRatingStars(),
//                     ElevatedButton(
//                       onPressed: _submitComment,
//                       child: const Text('Submit'),
//                     ),
//                   ] else ...[
//                     const SizedBox(height: 16),
//                     const Text('Please log in to add a comment.'),
//                   ]
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// lib/screens/place_detail_page.dart
//trial 4 start

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:mlaku_mlaku/services/place_service.dart';
// import 'package:mlaku_mlaku/models/place.dart';
// import 'package:mlaku_mlaku/screens/login.dart'; // For redirection if not authenticated

// class PlaceDetailPage extends StatefulWidget {
//   final int placeId;

//   const PlaceDetailPage({Key? key, required this.placeId}) : super(key: key);

//   @override
//   State<PlaceDetailPage> createState() => _PlaceDetailPageState();
// }

// class _PlaceDetailPageState extends State<PlaceDetailPage> {
//   late PlaceService _placeService;
//   Future<Place>? _placeFuture;

//   final _commentController = TextEditingController();
//   int _rating = 0; // rating from 1 to 5

//   @override
//   void initState() {
//     super.initState();
//     // Obtain the shared CookieRequest instance from Provider
//     final request = Provider.of<CookieRequest>(context, listen: false);
//     _placeService = PlaceService(request);
//     _loadPlaceDetail();
//   }

//   void _loadPlaceDetail() {
//     setState(() {
//       _placeFuture = _placeService.fetchPlaceDetail(widget.placeId);
//     });
//   }

//   Future<void> _submitComment() async {
//     final content = _commentController.text.trim();
//     if (content.isEmpty || _rating == 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Please provide both comment and rating.')),
//       );
//       return;
//     }

//     final request = Provider.of<CookieRequest>(context, listen: false);
//     if (!request.loggedIn) {
//       // If user not logged in, prompt login or redirect to login page
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('You are not logged in. Please log in first.')),
//       );
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const LoginPage()),
//       );
//       return;
//     }

//     try {
//       await _placeService.addComment(widget.placeId, content, _rating);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Comment added successfully!')),
//       );
//       _commentController.clear();
//       setState(() {
//         _rating = 0;
//       });
//       _loadPlaceDetail();
//     } catch (e) {
//       // Check if the error contains HTML login page
//       if (e.toString().contains('<title>Login') ||
//           e.toString().contains('SyntaxError') ||
//           e.toString().contains('Unexpected token')) {
//         // Session likely expired - redirect to login
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //               content: Text('Your session has expired. Please login again.')),
// //         );
// //         Navigator.of(context).pushReplacement(
// //           MaterialPageRoute(builder: (context) => const LoginPage()),
// //         );
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('Error adding comment: ${e.toString()}')),
// //         );
// //       }
// //     }
// //trial3 end
//     //   try {
//     //     // PlaceService uses the same domain http://10.0.2.2:8000
//     //     await _placeService.addComment(widget.placeId, content, _rating);
//     //     ScaffoldMessenger.of(context).showSnackBar(
//     //       const SnackBar(content: Text('Comment added successfully!')),
//     //     );
//     //     _commentController.clear();
//     //     setState(() {
//     //       _rating = 0;
//     //     });
//     //     _loadPlaceDetail(); // Refresh data after adding comment
//     //   } catch (e) {
//     //     // If the server sends HTML (redirect to login), or if there's any other error,
//     //     // it will be caught here
//     //     print("Full error response: $e");
//     //     ScaffoldMessenger.of(context).showSnackBar(
//     //       SnackBar(content: Text('Failed to add comment: $e')),
//     //     );
//     //   }
//     // }

//     //TRIAL2

// //     Widget _buildRatingStars() {
// //       return Row(
// //         children: List.generate(5, (index) {
// //           final starIndex = index + 1;
// //           return IconButton(
// //             icon: Icon(
// //               starIndex <= _rating ? Icons.star : Icons.star_border,
// //               color: Colors.yellow[700],
// //             ),
// //             onPressed: () {
// //               setState(() {
// //                 _rating = starIndex;
// //               });
// //             },
// //           );
// //         }),
// //       );
// //     }

// //     @override
// //     Widget build(BuildContext context) {
// //       final request = Provider.of<CookieRequest>(context);
// //       final isLoggedIn = request.loggedIn;

// //       return Scaffold(
// //         appBar: AppBar(
// //           title: const Text('Place Detail'),
// //           actions: [
// //             if (isLoggedIn)
// //               IconButton(
// //                 icon: const Icon(Icons.logout),
// //                 onPressed: () async {
// //                   // **Step 1:** Define your Django logout URL
// //                   // Replace '192.168.x.x' with your actual local IP address
// //                   // Ensure that this URL matches your Django logout endpoint
// //                   final logoutUrl =
// //                       'http://192.168.x.x:8000/accounts/logout_ajax/'; // Use your actual logout URL

// //                   try {
// //                     // **Step 2:** Call the logout method with the logout URL
// //                     final response = await request.logout(logoutUrl);

// //                     // **Step 3:** Check if logout was successful based on backend response
// //                     // Adjust the condition based on your backend's logout response
// //                     if (response['success'] == true) {
// //                       // **Step 4:** Navigate back to the LoginPage after successful logout
// //                       Navigator.of(context).pushReplacement(
// //                         MaterialPageRoute(
// //                             builder: (context) => const LoginPage()),
// //                       );
// //                     } else {
// //                       // **Step 5:** Show an error message if logout failed
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         const SnackBar(
// //                             content: Text('Logout failed. Please try again.')),
// //                       );
// //                     }
// //                   } catch (e) {
// //                     // **Step 6:** Handle any errors during logout
// //                     print("Logout error: $e");
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       const SnackBar(
// //                           content: Text('An error occurred during logout.')),
// //                     );
// //                   }
// //                 },
// //               ),
// //           ],
// //         ),
// //         body: FutureBuilder<Place>(
// //           future: _placeFuture,
// //           builder: (context, snapshot) {
// //             if (snapshot.connectionState == ConnectionState.waiting) {
// //               return const Center(child: CircularProgressIndicator());
// //             } else if (snapshot.hasError) {
// //               return Center(
// //                   child: Text('Error loading place: ${snapshot.error}'));
// //             }

// //             final place = snapshot.data!;
// //             return SingleChildScrollView(
// //               child: Padding(
// //                 padding: const EdgeInsets.all(16.0),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       place.name,
// //                       style: const TextStyle(
// //                           fontSize: 24, fontWeight: FontWeight.bold),
// //                     ),
// //                     Text('Average Rating: ${place.averageRating}/5'),
// //                     const SizedBox(height: 8),
// //                     Text(place.description),
// //                     const SizedBox(height: 16),
// //                     const Divider(),
// //                     const Text('Comments',
// //                         style: TextStyle(
// //                             fontSize: 18, fontWeight: FontWeight.bold)),
// //                     const SizedBox(height: 8),
// //                     if (place.comments.isEmpty)
// //                       const Text('No comments yet. Be the first to comment!'),
// //                     for (var c in place.comments) ...[
// //                       ListTile(
// //                         title: Text(c.username),
// //                         subtitle: Text(c.content),
// //                         trailing: Row(
// //                           mainAxisSize: MainAxisSize.min,
// //                           children: [
// //                             Text('${c.rating}/5'),
// //                             const Icon(Icons.star, color: Colors.yellow),
// //                           ],
// //                         ),
// //                       ),
// //                       const Divider(),
// //                     ],
// //                     const SizedBox(height: 16),
// //                     const Text('Souvenirs',
// //                         style: TextStyle(
// //                             fontSize: 18, fontWeight: FontWeight.bold)),
// //                     const SizedBox(height: 8),
// //                     if (place.souvenirs.isEmpty)
// //                       const Text('No souvenirs available.'),
// //                     for (var s in place.souvenirs) ...[
// //                       ListTile(
// //                         title: Text(s.name),
// //                         subtitle: Text('Price: ${s.price}, Stock: ${s.stock}'),
// //                       ),
// //                       const Divider(),
// //                     ],
// //                     if (isLoggedIn) ...[
// //                       const SizedBox(height: 16),
// //                       const Text('Add a Comment',
// //                           style: TextStyle(fontWeight: FontWeight.bold)),
// //                       TextField(
// //                         controller: _commentController,
// //                         decoration: const InputDecoration(
// //                           hintText: 'Write your comment...',
// //                         ),
// //                         maxLines: 3,
// //                       ),
// //                       const SizedBox(height: 8),
// //                       const Text('Your Rating:'),
// //                       _buildRatingStars(),
// //                       ElevatedButton(
// //                         onPressed: _submitComment,
// //                         child: const Text('Submit'),
// //                       ),
// //                     ] else ...[
// //                       const SizedBox(height: 16),
// //                       const Text('Please log in to add a comment.'),
// //                     ]
// //                   ],
// //                 ),
// //               ),
// //             );
// //           },
// //         ),
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     // TODO: implement build
// //     throw UnimplementedError();
// //   }
// // }

// //trial 3
// // lib/screens/place_detail_page.dart

// //trial fin cape
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:mlaku_mlaku/models/place.dart';
// import 'package:mlaku_mlaku/screens/login.dart'; // If you want to navigate to a login screen
// import 'package:mlaku_mlaku/services/place_service.dart';

// class PlaceDetailPage extends StatefulWidget {
//   final int placeId;

//   const PlaceDetailPage({Key? key, required this.placeId}) : super(key: key);

//   @override
//   State<PlaceDetailPage> createState() => _PlaceDetailPageState();
// }

// class _PlaceDetailPageState extends State<PlaceDetailPage> {
//   late PlaceService _placeService;
//   Future<Place>? _placeFuture;

//   final _commentController = TextEditingController();
//   int _rating = 0; // rating from 1 to 5

//   @override
//   void initState() {
//     super.initState();
//     // Obtain CookieRequest from Provider. This should already contain
//     // your session cookie if you’ve logged in successfully.
//     final request = Provider.of<CookieRequest>(context, listen: false);

//     // Pass the CookieRequest to PlaceService
//     _placeService = PlaceService(request);

//     // Load the place details
//     _loadPlaceDetail();
//   }

//   void _loadPlaceDetail() {
//     setState(() {
//       _placeFuture = _placeService.fetchPlaceDetail(widget.placeId);
//     });
//   }

//   /// Submits a new comment (content + rating) to the backend.
//   Future<void> _submitComment() async {
//     final content = _commentController.text.trim();
//     if (content.isEmpty || _rating == 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please provide both a comment and a rating.')),
//       );
//       return;
//     }

//     final request = Provider.of<CookieRequest>(context, listen: false);
//     if (!request.loggedIn) {
//       // If the user isn’t logged in, show a message or redirect to login
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('You are not logged in. Please log in first.')),
//       );
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const LoginPage()),
//       );
//       return;
//     }

//     try {
//       // Call our service’s addComment method
//       await _placeService.addComment(widget.placeId, content, _rating);

//       // Show success
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Comment added successfully!')),
//       );

//       // Clear the input fields
//       _commentController.clear();
//       setState(() {
//         _rating = 0;
//       });

//       // Refresh the place detail to show the new comment
//       _loadPlaceDetail();
//     } catch (e) {
//       // If there's an error, show it in a snack bar
//       print("Full error response: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to add comment: $e')),
//       );
//     }
//   }

//   /// Builds a row of 5 star icons to set the rating.
//   Widget _buildRatingStars() {
//     return Row(
//       children: List.generate(5, (index) {
//         final starIndex = index + 1;
//         return IconButton(
//           icon: Icon(
//             starIndex <= _rating ? Icons.star : Icons.star_border,
//             color: Colors.yellow[700],
//           ),
//           onPressed: () {
//             setState(() {
//               _rating = starIndex;
//             });
//           },
//         );
//       }),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Check if the user is logged in. This affects our UI logic
//     final request = Provider.of<CookieRequest>(context);
//     final isLoggedIn = request.loggedIn;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Place Detail'),
//       ),
//       body: FutureBuilder<Place>(
//         future: _placeFuture,
//         builder: (context, snapshot) {
//           // If still loading, show a progress indicator
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           // If there's an error, display it
//           else if (snapshot.hasError) {
//             return Center(child: Text('Error loading place: ${snapshot.error}'));
//           }

//           // At this point, we have our place data
//           final place = snapshot.data!;
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Place name
//                   Text(
//                     place.name,
//                     style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   // Average rating
//                   Text('Average Rating: ${place.averageRating}/5'),
//                   const SizedBox(height: 8),
//                   // Description
//                   Text(place.description),
//                   const SizedBox(height: 16),
//                   const Divider(),
//                   // Comments
//                   const Text(
//                     'Comments',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   if (place.comments.isEmpty)
//                     const Text('No comments yet. Be the first to comment!'),
//                   for (var c in place.comments) ...[
//                     ListTile(
//                       title: Text(c.username),
//                       subtitle: Text(c.content),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text('${c.rating}/5'),
//                           const Icon(Icons.star, color: Colors.yellow),
//                         ],
//                       ),
//                     ),
//                     const Divider(),
//                   ],

//                   // Souvenirs section
//                   const SizedBox(height: 16),
//                   const Text('Souvenirs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   if (place.souvenirs.isEmpty)
//                     const Text('No souvenirs available.'),
//                   for (var s in place.souvenirs) ...[
//                     ListTile(
//                       title: Text(s.name),
//                       subtitle: Text('Price: ${s.price}, Stock: ${s.stock}'),
//                     ),
//                     const Divider(),
//                   ],

//                   // Add comment form if logged in
//                   if (isLoggedIn) ...[
//                     const SizedBox(height: 16),
//                     const Text('Add a Comment', style: TextStyle(fontWeight: FontWeight.bold)),
//                     TextField(
//                       controller: _commentController,
//                       decoration: const InputDecoration(
//                         hintText: 'Write your comment...',
//                       ),
//                       maxLines: 3,
//                     ),
//                     const SizedBox(height: 8),
//                     const Text('Your Rating:'),
//                     _buildRatingStars(),
//                     ElevatedButton(
//                       onPressed: _submitComment,
//                       child: const Text('Submit'),
//                     ),
//                   ] else ...[
//                     // If not logged in, prompt them to log in
//                     const SizedBox(height: 16),
//                     const Text('Please log in to add a comment.'),
//                   ]
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// //end trial fin cape

// //starover claude

// import 'package:flutter/material.dart';
// import 'package:mlaku_mlaku/services/place_service.dart';
// import 'package:mlaku_mlaku/models/place.dart';
// import 'package:mlaku_mlaku/services/place_service.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:provider/provider.dart';

// class PlaceDetailScreen extends StatefulWidget {
//   final int placeId;

//   const PlaceDetailScreen({Key? key, required this.placeId}) : super(key: key);

//   @override
//   _PlaceDetailScreenState createState() => _PlaceDetailScreenState();
// }

// class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
//   late Future<Place> _placeFuture;
//   late PlaceService _placeService;

//   @override
//   void initState() {
//     super.initState();
//     final request = context.read<CookieRequest>();
//     _placeService = PlaceService(request);
//     _refreshPlace();
//   }

//   void _refreshPlace() {
//     setState(() {
//       _placeFuture = _placeService.getPlaceDetails(widget.placeId);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final request = context.watch<CookieRequest>();
//     final isLoggedIn = request.loggedIn;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Place Details'),
//       ),
//       body: FutureBuilder<Place>(
//         future: _placeFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           final place = snapshot.data!;
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   place.name,
//                   style: Theme.of(context).textTheme.headlineMedium,
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     const Icon(Icons.star, color: Colors.amber),
//                     Text(' ${place.averageRating.toStringAsFixed(1)}'),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Text(place.description),
//                 const SizedBox(height: 24),
//                 _buildSouvenirsList(place),
//                 const SizedBox(height: 24),
//                 _buildCommentsList(place),
//               ],
//             ),
//           );
//         },
//       ),
//       floatingActionButton: isLoggedIn
//           ? FloatingActionButton(
//               onPressed: () => _showAddCommentDialog(context),
//               child: const Icon(Icons.add_comment),
//             )
//           : null,
//     );
//   }

//   Widget _buildSouvenirsList(Place place) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Souvenirs',
//           style: Theme.of(context).textTheme.titleLarge,
//         ),
//         const SizedBox(height: 8),
//         ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: place.souvenirs.length,
//           itemBuilder: (context, index) {
//             final souvenir = place.souvenirs[index];
//             return Card(
//               child: ListTile(
//                 title: Text(souvenir.name),
//                 subtitle: Text('Price: ${souvenir.price}, Stock: ${souvenir.stock}'),
//                 trailing: ElevatedButton(
//                   onPressed: souvenir.stock > 0
//                       ? () => _buySouvenir(souvenir.id)
//                       : null,
//                   child: const Text('Buy'),
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildCommentsList(Place place) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Comments',
//           style: Theme.of(context).textTheme.titleLarge,
//         ),
//         const SizedBox(height: 8),
//         ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: place.comments.length,
//           itemBuilder: (context, index) {
//             final comment = place.comments[index];
//             return Card(
//               child: ListTile(
//                 title: Row(
//                   children: [
//                     Text(comment.username),
//                     const Spacer(),
//                     Text('${comment.rating}/5 '),
//                     const Icon(Icons.star, color: Colors.amber, size: 16),
//                   ],
//                 ),
//                 subtitle: Text(comment.content),
//                 trailing: context.read<CookieRequest>().loggedIn
//                     ? PopupMenuButton(
//                         itemBuilder: (context) => [
//                           const PopupMenuItem(
//                             value: 'edit',
//                             child: Text('Edit'),
//                           ),
//                           const PopupMenuItem(
//                             value: 'delete',
//                             child: Text('Delete'),
//                           ),
//                         ],
//                         onSelected: (value) {
//                           if (value == 'edit') {
//                             _showEditCommentDialog(context, comment);
//                           } else if (value == 'delete') {
//                             _showDeleteCommentDialog(context, comment.id);
//                           }
//                         },
//                       )
//                     : null,
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Future<void> _showAddCommentDialog(BuildContext context) async {
//     final textController = TextEditingController();
//     int rating = 5;

//     return showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           title: const Text('Add Comment'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: textController,
//                 decoration: const InputDecoration(
//                   labelText: 'Comment',
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 3,
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(
//                   5,
//                   (index) => IconButton(
//                     icon: Icon(
//                       index < rating ? Icons.star : Icons.star_border,
//                       color: Colors.amber,
//                     ),
//                     onPressed: () => setState(() => rating = index + 1),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   await _placeService.addComment(
//                     widget.placeId,
//                     textController.text,
//                     rating,
//                   );
//                   if (!mounted) return;
//                   Navigator.pop(context);
//                   _refreshPlace();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Comment added successfully')),
//                   );
//                 } catch (e) {
//                   if (!mounted) return;
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Error: $e')),
//                   );
//                 }
//               },
//               child: const Text('Add'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _showEditCommentDialog(BuildContext context, Comment comment) async {
//     final textController = TextEditingController(text: comment.content);
//     int rating = comment.rating;

//     return showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           title: const Text('Edit Comment'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: textController,
//                 decoration: const InputDecoration(
//                   labelText: 'Comment',
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 3,
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(
//                   5,
//                   (index) => IconButton(
//                     icon: Icon(
//                       index < rating ? Icons.star : Icons.star_border,
//                       color: Colors.amber,
//                     ),
//                     onPressed: () => setState(() => rating = index + 1),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   await _placeService.editComment(
//                     comment.id,
//                     textController.text,
//                     rating,
//                   );
//                   if (!mounted) return;
//                   Navigator.pop(context);
//                   _refreshPlace();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Comment updated successfully')),
//                   );
//                 } catch (e) {
//                   if (!mounted) return;
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Error: $e')),
//                   );
//                 }
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _showDeleteCommentDialog(BuildContext context, int commentId) {
//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Comment'),
//         content: const Text('Are you sure you want to delete this comment?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             onPressed: () async {
//               try {
//                 await _placeService.deleteComment(commentId);
//                 if (!mounted) return;
//                 Navigator.pop(context);
//                 _refreshPlace();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Comment deleted successfully')),
//                 );
//               } catch (e) {
//                 if (!mounted) return;
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Error: $e')),
//                 );
//               }
//             },
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _buySouvenir(int souvenirId) async {
//     try {
//       await _placeService.buySouvenir(souvenirId);
//       _refreshPlace();
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Souvenir purchased successfully')),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }
// }// fin claude

//2nd start over claude
import 'package:flutter/material.dart';
import 'package:mlaku_mlaku/services/place_service.dart';
import 'package:mlaku_mlaku/models/place.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class PlaceDetailScreen extends StatefulWidget {
  final int placeId;

  const PlaceDetailScreen({Key? key, required this.placeId}) : super(key: key);

  @override
  _PlaceDetailScreenState createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  late Future<Place> _placeFuture;
  late PlaceService _placeService;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    _placeService = PlaceService(request);
    _refreshPlace();
  }

  void _refreshPlace() {
    setState(() {
      _placeFuture = _placeService.getPlaceDetails(widget.placeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final isLoggedIn = request.loggedIn;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Details'),
      ),
      body: FutureBuilder<Place>(
        future: _placeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final place = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    Text(' ${place.averageRating.toStringAsFixed(1)}'),
                  ],
                ),
                const SizedBox(height: 16),
                Text(place.description),
                const SizedBox(height: 24),
                _buildSouvenirsList(place),
                const SizedBox(height: 24),
                _buildCommentsList(place),
              ],
            ),
          );
        },
      ),
      floatingActionButton: isLoggedIn
          ? FloatingActionButton(
              onPressed: () => _showAddCommentDialog(context),
              child: const Icon(Icons.add_comment),
            )
          : null,
    );
  }

  Widget _buildSouvenirsList(Place place) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Souvenirs',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: place.souvenirs.length,
          itemBuilder: (context, index) {
            final souvenir = place.souvenirs[index];
            return Card(
              child: ListTile(
                title: Text(souvenir.name),
                subtitle:
                    Text('Price: ${souvenir.price}, Stock: ${souvenir.stock}'),
                trailing: ElevatedButton(
                  onPressed: souvenir.stock > 0
                      ? () => _buySouvenir(souvenir.id)
                      : null,
                  child: const Text('Buy'),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCommentsList(Place place) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comments',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: place.comments.length,
          itemBuilder: (context, index) {
            final comment = place.comments[index];
            return Card(
              child: ListTile(
                title: Row(
                  children: [
                    Text(comment.username),
                    const Spacer(),
                    Text('${comment.rating}/5 '),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                  ],
                ),
                subtitle: Text(comment.content),
                trailing: context.read<CookieRequest>().loggedIn
                    ? PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditCommentDialog(context, comment);
                          } else if (value == 'delete') {
                            _showDeleteCommentDialog(context, comment.id);
                          }
                        },
                      )
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _showAddCommentDialog(BuildContext context) async {
    final textController = TextEditingController();
    int rating = 5;

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Comment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'Comment',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () => setState(() => rating = index + 1),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (textController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a comment')),
                  );
                  return;
                }

                try {
                  await _placeService.addComment(
                    widget.placeId,
                    textController.text,
                    rating,
                  );
                  if (!mounted) return;
                  Navigator.pop(context);
                  _refreshPlace(); // Refresh immediately after adding
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Comment added successfully')),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditCommentDialog(
      BuildContext context, Comment comment) async {
    final textController = TextEditingController(text: comment.content);
    int rating = comment.rating;

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Comment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'Comment',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () => setState(() => rating = index + 1),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (textController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a comment')),
                  );
                  return;
                }

                try {
                  print(comment.id);
                  print(textController.text);
                  print(rating);
                  await _placeService.editComment(
                    comment.id,
                    textController.text,
                    rating,
                  );
                  if (!mounted) return;
                  Navigator.pop(context);
                  _refreshPlace(); // Refresh immediately after editing
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Comment updated successfully')),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteCommentDialog(BuildContext context, int commentId) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              try {
                await _placeService.deleteComment(commentId);
                if (!mounted) return;
                Navigator.pop(context);
                _refreshPlace(); // Refresh immediately after deleting
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Comment deleted successfully')),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _buySouvenir(int souvenirId) async {
    try {
      await _placeService.buySouvenir(souvenirId);
      _refreshPlace(); // Refresh immediately after purchase
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Souvenir purchased successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
