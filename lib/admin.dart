import 'package:flutter/material.dart';
import 'package:mlaku_mlaku_mobile/login_admin.dart';
import 'package:mlaku_mlaku_mobile/models/place.dart';
import 'package:mlaku_mlaku_mobile/models/souvenir.dart';

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

  List<Place> places = [];
  String? selectedPlace;
  int nextPlaceId = 1;
  int nextSouvenirId = 1;
  bool isEditingPlace = false;
  Place? editingPlace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                isEditingPlace
                    ? "Edit ${editingPlace?.name}"
                    : "Add Places",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildInputField("Name", placeNameController),
              _buildInputField("Description", placeDescriptionController),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3279E6),
                  foregroundColor: const Color(0xFFF7F7F7),
                ),
                onPressed: isEditingPlace ? _savePlaceChanges : _addPlace,
                child: Text(isEditingPlace ? "Save Changes" : "Assign Place"),
              ),
              const SizedBox(height: 20),

              const Text(
                "Add Souvenirs",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildInputField("Name", souvenirNameController),
              _buildInputField("Price", souvenirPriceController),
              _buildInputField("Stock", souvenirStockController),
              const SizedBox(height: 10),
              _buildDropdown(),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3279E6),
                  foregroundColor: const Color(0xFFF7F7F7),
                ),
                onPressed: _addSouvenir,
                child: const Text("Assign Souvenir"),
              ),
              const SizedBox(height: 30),

              const Text(
                "List Places",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${places[index].id}. ${places[index].name}"),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _editPlace(places[index]);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deletePlace(places[index]);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {},
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3279E6),
                  foregroundColor: const Color(0xFFF7F7F7),
                ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
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
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const Text("Add to place: "),
          DropdownButton<String>(
            value: selectedPlace,
            hint: const Text("Select a place"),
            items: places.map((place) {
              return DropdownMenuItem(value: place.name, child: Text(place.name));
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedPlace = value;
              });
            },
          ),
        ],
      ),
    );
  }

  void _addPlace() {
    final name = placeNameController.text;
    final description = placeDescriptionController.text;

    if (name.isEmpty || description.isEmpty) {
      _showErrorSnackbar("Please fill in all fields.");
      return;
    }

    if (name.length < 5 || name.length > 20) {
      _showErrorSnackbar("Place name must be between 5 and 20 characters.");
      return;
    }
    if (description.length < 5 || description.length > 1000) {
      _showErrorSnackbar("Place description must be between 5 and 1000 characters.");
      return;
    }

    setState(() {
      final newPlace = Place(
        id: nextPlaceId++,
        name: name,
        description: description,
        averageRating: 0,
        comments: [],
        souvenirs: [],
      );

      places.add(newPlace);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("A new place '${newPlace.name}' has just been created!")),
      );

      placeNameController.clear();
      placeDescriptionController.clear();
    });
  }

  void _editPlace(Place place) {
    setState(() {
      isEditingPlace = true;
      editingPlace = place;
      placeNameController.text = place.name;
      placeDescriptionController.text = place.description;
    });
  }

  void _savePlaceChanges() {
    final name = placeNameController.text;
    final description = placeDescriptionController.text;

    if (name.isEmpty || description.isEmpty) {
      _showErrorSnackbar("Please fill in all fields.");
      return;
    }

    if (name.length < 5 || name.length > 20) {
      _showErrorSnackbar("Place name must be between 5 and 20 characters.");
      return;
    }
    if (description.length < 5 || description.length > 1000) {
      _showErrorSnackbar("Place description must be between 5 and 1000 characters.");
      return;
    }

    setState(() {
      editingPlace!.name = name;
      editingPlace!.description = description;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Place '${editingPlace!.name}' has been updated!")),
      );

      isEditingPlace = false;
      placeNameController.clear();
      placeDescriptionController.clear();
    });
  }

  void _deletePlace(Place place) {
    setState(() {
      places.remove(place);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Place '${place.name}' has been deleted!")),
      );
    });
  }

  void _addSouvenir() {
    final name = souvenirNameController.text;
    final priceText = souvenirPriceController.text;
    final stockText = souvenirStockController.text;

    if (name.isEmpty || priceText.isEmpty || stockText.isEmpty || selectedPlace == null) {
      _showErrorSnackbar("Please fill in all fields and select a place.");
      return;
    }

    if (name.length < 5 || name.length > 20) {
      _showErrorSnackbar("Souvenir name must be between 5 and 20 characters.");
      return;
    }
    if (!RegExp(r'^[0-9]+(\.[0-9]{1,2})?$').hasMatch(priceText) || double.tryParse(priceText) == null || double.parse(priceText) <= 0) {
      _showErrorSnackbar("Souvenir price must be a positive number.");
      return;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(stockText) || int.tryParse(stockText) == null || int.parse(stockText) <= 0) {
      _showErrorSnackbar("Souvenir stock must be a positive integer.");
      return;
    }

    final selectedPlaceObject = places.firstWhere((place) => place.name == selectedPlace);
    final newSouvenir = Souvenir(
      id: nextSouvenirId++,
      name: name,
      price: double.parse(priceText),
      stock: int.parse(stockText),
    );

    setState(() {
      selectedPlaceObject.souvenirs.add(newSouvenir);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("A new souvenir '${newSouvenir.name}' has been added to '${selectedPlaceObject.name}'!")),
      );

      souvenirNameController.clear();
      souvenirPriceController.clear();
      souvenirStockController.clear();
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _dismissAdmin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginAdminPage()),
    );
  }
}