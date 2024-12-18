// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class CookieRequest {
//   late String _username; // Mark as late
//   bool loggedIn = false; // Status login

//   // Getter untuk username
//   String get username => _username;

//   // Metode untuk mengatur username saat login
//   void setUsername(String username) {
//     _username = username;
//     loggedIn = true; // Set status login ke true
//   }

//   // Metode untuk login
//   Future<Map<String, dynamic>> login(String url, Map<String, String> body) async {
//     final response = await http.post(Uri.parse(url), body: body);
//     if (response.statusCode == 200) {
//       // Misalkan response berisi JSON dengan 'username' dan 'message'
//       final data = jsonDecode(response.body);
//       setUsername(data['username']); // Simpan username saat login berhasil
//       return data;
//     } else {
//       // Tangani kesalahan
//       return {'message': 'Login failed'};
//     }
//   }

//   // Metode lain yang diperlukan untuk CookieRequest
// } 