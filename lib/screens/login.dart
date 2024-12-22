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
                        final customRequest = context.read<CustomCookieRequest>();


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
                        customRequest.userName = uname;  // Add this line to set the username


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
