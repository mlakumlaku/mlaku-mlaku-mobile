import 'package:flutter/material.dart';
import 'package:mlaku_mlaku_mobile/admin.dart';

class LoginAdminPage extends StatefulWidget {
  const LoginAdminPage({super.key});

  @override
  State<LoginAdminPage> createState() => _LoginAdminPageState();
}

class _LoginAdminPageState extends State<LoginAdminPage> {
  final TextEditingController _credentialController = TextEditingController();
  bool _isAdmin = false;

  void _authorizeAdmin() {
    if (_credentialController.text == "adminmlaku123") {
      setState(() {
        _isAdmin = true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Admin Credential")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Get Admin Access",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text("Admin credential: "),
                  Expanded(
                    child: TextField(
                      controller: _credentialController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _authorizeAdmin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3279E6),
                  foregroundColor: const Color(0xFFF7F7F7),
                  minimumSize: const Size(130, 32),
                ),
                child: const Text("Authorize"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}