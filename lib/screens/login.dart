// // import 'package:mlaku_mlaku/screens/menu.dart';
// import 'package:flutter/material.dart';
// import 'package:mlaku_mlaku/screens/menu.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:mlaku_mlaku/screens/register.dart';
// import 'package:mlaku_mlaku/main.dart';

// // TODO: Import halaman RegisterPage jika sudah dibuat

// void main() {
//   runApp(const LoginApp());
// }

// class LoginApp extends StatelessWidget {
//   const LoginApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Login',
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSwatch(
//           primarySwatch: Colors.deepPurple,
//         ).copyWith(secondary: Colors.deepPurple[400]),
//       ),
//       home: const LoginPage(),
//     );
//   }
// }

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final request = context.watch<CookieRequest>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Card(
//             elevation: 8,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12.0),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     'Login',
//                     style: TextStyle(
//                       fontSize: 24.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 30.0),
//                   TextField(
//                     controller: _usernameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Username',
//                       hintText: 'Enter your username',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(12.0)),
//                       ),
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//                     ),
//                   ),
//                   const SizedBox(height: 12.0),
//                   TextField(
//                     controller: _passwordController,
//                     decoration: const InputDecoration(
//                       labelText: 'Password',
//                       hintText: 'Enter your password',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(12.0)),
//                       ),
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//                     ),
//                     obscureText: true,
//                   ),
//                   const SizedBox(height: 24.0),
//                   ElevatedButton(
//                     onPressed: () async {
//                       String username = _usernameController.text;
//                       String password = _passwordController.text;

//                       // Cek kredensial
//                       // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
//                       // Untuk menyambungkan Android emulator dengan Django pada 127.0.0.1,
//                       // gunakan URL http://10.0.2.2/
//                       final response = await request
//                           .login("http://127.0.0.1:8000/auth/login/", {
//                         'username': username,
//                         'password': password,
//                       });

//                       if (request.loggedIn) {
//                         String message = response['message'];
//                         String uname = response['username'];
//                         if (context.mounted) {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const MyHomePage(title: "Mlaku-Mlaku")),
//                           );
//                           ScaffoldMessenger.of(context)
//                             ..hideCurrentSnackBar()
//                             ..showSnackBar(
//                               SnackBar(
//                                   content:
//                                       Text("$message Selamat datang, $uname.")),
//                             );
//                         }
//                       } else {
//                         if (context.mounted) {
//                           showDialog(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               title: const Text('Login Gagal'),
//                               content: Text(response['message']),
//                               actions: [
//                                 TextButton(
//                                   child: const Text('OK'),
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                 ),
//                               ],
//                             ),
//                           );
//                         }
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.white,
//                       minimumSize: Size(double.infinity, 50),
//                       backgroundColor: Theme.of(context).colorScheme.primary,
//                       padding: const EdgeInsets.symmetric(vertical: 16.0),
//                     ),
//                     child: const Text('Login'),
//                   ),
//                   const SizedBox(height: 36.0),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const RegisterPage()),
//                       );
//                     },
//                     child: Text(
//                       'Don\'t have an account? Register',
//                       style: TextStyle(
//                         color: Theme.of(context).colorScheme.primary,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


















// import 'package:flutter/material.dart';
// import 'package:mlaku_mlaku/screens/menu.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:mlaku_mlaku/screens/register.dart';
// import 'package:mlaku_mlaku/main.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   // For Android emulator, use http://10.0.2.2:8000
//   // For iOS simulator, or if you're running a real device via USB, you might need a different IP.
//   final String djangoLoginUrl = "http://127.0.0.1:8000/auth/login/";

//   @override
//   Widget build(BuildContext context) {
//     final request = context.watch<CookieRequest>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Card(
//             elevation: 8,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12.0),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     'Login',
//                     style: TextStyle(
//                       fontSize: 24.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 30.0),
//                   TextField(
//                     controller: _usernameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Username',
//                       hintText: 'Enter your username',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(12.0)),
//                       ),
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//                     ),
//                   ),
//                   const SizedBox(height: 12.0),
//                   TextField(
//                     controller: _passwordController,
//                     decoration: const InputDecoration(
//                       labelText: 'Password',
//                       hintText: 'Enter your password',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(12.0)),
//                       ),
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//                     ),
//                     obscureText: true,
//                   ),
//                   const SizedBox(height: 24.0),
//                   ElevatedButton(
//                         onPressed: () async {
//                           final username = _usernameController.text;
//                           final password = _passwordController.text;

//                           // Attempt to log in to Django
//                           final response = await request.login(djangoLoginUrl, {
//                               'username': username,
//                               'password': password,
//                           });

//                           // Store session ID in CookieRequest headers if login successful
//                           if (request.loggedIn) {
//                               final sessionId = response['sessionid'];
//                               if (sessionId != null) {
//                                   request.headers['cookie'] = 'sessionid=$sessionId';
//                                   print("Set session cookie: ${request.headers['cookie']}");
//                               }
                              
//                               // Rest of your existing login success code...
//                               print("Are we logged in? ${request.loggedIn}");
//                               final message = response['message'];
//                               final uname = response['username'] ?? username;
                              
//                               if (!mounted) return;
//                               Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => const MyHomePage(title: "Mlaku-Mlaku"),
//                                   ),
//                               );
//                               ScaffoldMessenger.of(context)
//                                   ..hideCurrentSnackBar()
//                                   ..showSnackBar(
//                                       SnackBar(content: Text("$message Selamat datang, $uname.")),
//                                   );
//                           } else {
//                               print("Login failed: $response");
//                               if (!mounted) return;
//                               showDialog(
//                                   context: context,
//                                   builder: (context) => AlertDialog(
//                                       title: const Text('Login Gagal'),
//                                       content: Text(response['message'] ?? 'Unknown error.'),
//                                       actions: [
//                                           TextButton(
//                                               child: const Text('OK'),
//                                               onPressed: () {
//                                                   Navigator.pop(context);
//                                               },
//                                           ),
//                                       ],
//                                   ),
//                               );
//                           }
//                       },
//                     // onPressed: () async {
//                     //   final username = _usernameController.text;
//                     //   final password = _passwordController.text;

//                     //   // Attempt to log in to Django
//                     //   final response = await request.login(djangoLoginUrl, {
//                     //     'username': username,
//                     //     'password': password,
//                     //   });

//                     //   // Check if logged in
//                     //   if (request.loggedIn) {
//                     //     print("Are we logged in? ${request.loggedIn}");
//                     //     final message = response['message'];
//                     //     final uname = response['username'] ?? username;
//                     //     if (!mounted) return;

//                     //     // Navigate to home page or wherever you want
//                     //     Navigator.pushReplacement(
//                     //       context,
//                     //       MaterialPageRoute(
//                     //         builder: (context) =>
//                     //             const MyHomePage(title: "Mlaku-Mlaku"),
//                     //       ),
//                     //     );
//                     //     ScaffoldMessenger.of(context)
//                     //       ..hideCurrentSnackBar()
//                     //       ..showSnackBar(
//                     //         SnackBar(
//                     //             content:
//                     //                 Text("$message Selamat datang, $uname.")),
//                     //       );
//                     //   } else {
//                     //     // Login failed
//                     //     if (!mounted) return;
//                     //     showDialog(
//                     //       context: context,
//                     //       builder: (context) => AlertDialog(
//                     //         title: const Text('Login Gagal'),
//                     //         content:
//                     //             Text(response['message'] ?? 'Unknown error.'),
//                     //         actions: [
//                     //           TextButton(
//                     //             child: const Text('OK'),
//                     //             onPressed: () {
//                     //               Navigator.pop(context);
//                     //             },
//                     //           ),
//                     //         ],
//                     //       ),
//                     //     );
//                     //   }
//                     // },
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.white,
//                       minimumSize: const Size(double.infinity, 50),
//                       backgroundColor: Theme.of(context).colorScheme.primary,
//                       padding: const EdgeInsets.symmetric(vertical: 16.0),
//                     ),
//                     child: const Text('Login'),
//                   ),
//                   const SizedBox(height: 36.0),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const RegisterPage()),
//                       );
//                     },
//                     child: Text(
//                       'Don\'t have an account? Register',
//                       style: TextStyle(
//                         color: Theme.of(context).colorScheme.primary,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:mlaku_mlaku/screens/menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mlaku_mlaku/screens/register.dart';
import 'package:mlaku_mlaku/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // For Android emulator, use: http://10.0.2.2:8000
  // For iOS simulator or real device, you may need a different IP.
  final String djangoLoginUrl = "http://127.0.0.1:8000/auth/login/";

  @override
  Widget build(BuildContext context) {
    /// This [CookieRequest] is from `package:pbp_django_auth/pbp_django_auth.dart`
    /// It typically handles cookies automatically.
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () async {
                      // Get username/password
                      final username = _usernameController.text;
                      final password = _passwordController.text;

                      // Attempt to log in
                      final response = await request.login(djangoLoginUrl, {
                        'username': username,
                        'password': password,
                      });

                      // 'response' is a Map (JSON from Django)
                      // Example of response:
                      // {
                      //   "status": true,
                      //   "message": "Login sukses!",
                      //   "username": "alice",
                      //   "sessionid": "abc123xyz"
                      // }

                      // Check if Django side said status = True
                      if (response['status'] == true) {
                        print("Raw response: $response");

                        // If using pbp_django_auth, request.loggedIn should be true
                        print("Are we logged in? ${request.loggedIn}");

                        // OPTIONAL: Manually set the session cookie if you want
                        // to ensure future requests have 'sessionid=XYZ'.
                        // However, pbp_django_auth might already do this for you.
                        final sessionId = response['sessionid'];
                        if (sessionId != null) {
                          request.headers['cookie'] = 'sessionid=$sessionId';
                          print("Set session cookie: ${request.headers['cookie']}");
                        }

                        // Show success message
                        final message = response['message'] ?? 'Login sukses!';
                        final uname = response['username'] ?? username;

                        if (!mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const MyHomePage(title: "Mlaku-Mlaku"),
                          ),
                        );

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text("$message Selamat datang, $uname."),
                            ),
                          );
                      } else {
                        // If 'status' is not true, handle as login failure
                        print("Login failed: $response");
                        if (!mounted) return;

                        final errorMsg = response['message'] ?? 'Unknown error.';
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Login Gagal'),
                            content: Text(errorMsg),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 36.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    child: Text(
                      'Don\'t have an account? Register',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
