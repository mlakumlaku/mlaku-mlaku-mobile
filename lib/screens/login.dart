import 'package:flutter/material.dart';
import 'package:mlaku_mlaku/screens/menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mlaku_mlaku/screens/register.dart';
import 'package:mlaku_mlaku/main.dart'; 
import 'package:flutter/foundation.dart';



class CustomCookieRequest extends CookieRequest with ChangeNotifier {
  String? _userId; // Private variable to store userId
  String? _userName; // Private variable to store userName

  // Getter for userId
  String? get userId => _userId;
  

  // Setter for userId
  set userId(String? id) {
    _userId = id;
    notifyListeners(); // Notify listeners when userId changes
  }

  // Getter for userName
  String? get userName => _userName;

  // Setter for userName
  set userName(String? name) {
    _userName = name;
    notifyListeners(); // Notify listeners when userName changes
  }

}

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Travel Friend!',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ).copyWith(secondary: Colors.deepPurple[400]),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Travel Buddy!'),
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () async {
                      String username = _usernameController.text;
                      String password = _passwordController.text;

                      // Access the request as CustomCookieRequest
                      final request = context.read<CustomCookieRequest>();

                      final response = await request.login("https://nur-khoirunnisa-mlakumlaku2.pbp.cs.ui.ac.id/auth/login/", {
                          'username': username,
                          'password': password,
                      });

                      if (request.loggedIn) {
                          String message = response['message'];
                          String uname = response['username'];
                          
                          // Ensure userId is a string
                          String userId = response['userId'].toString(); // Convert to String if it's an int

                          // Store userId and userName in CustomCookieRequest
                          request.userId = userId; // Now this works without error
                          request.userName = uname; // Set the userName

                          if (context.mounted) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MyHomePage(title: "Mlaku-Mlaku")),
                              );
                              ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                      SnackBar(content: Text("$message Selamat datang, $uname.")),
                                  );
                          }
                      } else {
                          if (context.mounted) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                      title: const Text('Login Gagal'),
                                      content: Text(response['message']),
                                      actions: [
                                          TextButton(
                                              child: const Text('OK'),
                                              onPressed: () {
                                                  Navigator.pop(context);
                                              },
                                          ),
                                      ],
                                  ),
                              );
                          }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
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