import 'package:flutter/material.dart';
import 'package:mlaku_mlaku_mobile/login_admin.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  AdminPageState createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  final TextEditingController placeNameController = TextEditingController();
  final TextEditingController placeDescriptionController = TextEditingController();
  final TextEditingController souvenirNameController = TextEditingController();
  final TextEditingController souvenirPriceController = TextEditingController();
  final TextEditingController souvenirStockController = TextEditingController();

  List<String> places = [];
  String selectedPlace = "No places added";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add Places Section
              const Text(
                "Add Places",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildInputField("Name", placeNameController),
              _buildInputField("Description", placeDescriptionController),
              _buildFileInput("Image"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addPlace,
                child: const Text("Assign Place"),
              ),
              const SizedBox(height: 30),

              // Add Souvenirs Section
              const Text(
                "Add Souvenirs",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildInputField("Name", souvenirNameController),
              _buildInputField("Price", souvenirPriceController),
              _buildInputField("Stock", souvenirStockController),
              _buildFileInput("Image"),
              const SizedBox(height: 10),
              _buildDropdown(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addSouvenir,
                child: const Text("Assign Souvenir"),
              ),
              const SizedBox(height: 30),

              // List Places Section
              const Text(
                "List Places",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(places[index]),
                      onTap: () {
                        // Handle place selection
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),

              // Dismiss Admin Section
              ElevatedButton(
                onPressed: _dismissAdmin,
                child: const Text("Dismiss As Admin"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Row(
      children: [
        Text('$label: '),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileInput(String label) {
    return Row(
      children: [
        Text('$label: '),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: () {
                // Handle file selection
              },
              child: const Text("Choose File"),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Row(
      children: [
        const Text("Add to place: "),
        DropdownButton<String>(
          value: selectedPlace,
          items: places.isNotEmpty
              ? places.map((place) {
                  return DropdownMenuItem(value: place, child: Text(place));
                }).toList()
              : const [
                  DropdownMenuItem(
                    value: "No places added",
                    child: Text("No places added"),
                  ),
                ],
          onChanged: (value) {
            setState(() {
              selectedPlace = value ?? "No places added";
            });
          },
        ),
      ],
    );
  }

  void _addPlace() {
    if (placeNameController.text.isNotEmpty) {
      setState(() {
        places.add(placeNameController.text);
        placeNameController.clear();
        placeDescriptionController.clear();
      });
    }
  }

  void _addSouvenir() {
    // Handle souvenir addition
  }

  void _dismissAdmin() {
    // Navigate back to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginAdminPage()),
    );
  }
}