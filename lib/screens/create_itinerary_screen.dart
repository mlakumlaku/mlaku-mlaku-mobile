import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class CreateItineraryScreen extends StatefulWidget {
  const CreateItineraryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateItineraryScreenState createState() => _CreateItineraryScreenState();
}

class _CreateItineraryScreenState extends State<CreateItineraryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final List<ItineraryDay> _days = [];
  final List<Itinerary> _itineraries = [];
  List<Place> _places = [];

  @override
  void initState() {
    super.initState();
    _loadPlacesData();
  }

  Future<void> _loadPlacesData() async {
    final places = await loadPlaces();
    setState(() {
      _places = places;
    });
  }

  void _addDay() {
    setState(() {
      _days.add(ItineraryDay(
        dayNumber: _days.length + 1,
        date: '',
        destinations: [],
      ));
    });
  }

  void _addDestination(int dayIndex) {
    setState(() {
      _days[dayIndex].destinations.add(
        Destination(name: '', time: null),
      );
    });
  }

  void _editItinerary(int index) {
    setState(() {
      _nameController.text = _itineraries[index].name;
      _days.clear();
      _days.addAll(_itineraries[index].days);
      _itineraries.removeAt(index);
    });
  }

  void _deleteItinerary(int index) {
    setState(() {
      _itineraries.removeAt(index);
    });
  }

  Future<void> _pickDate(int index) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _days[index].dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  Future<void> _pickTime(int dayIndex, int destinationIndex) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {
        _days[dayIndex].destinations[destinationIndex].timeController.text = selectedTime.format(context);
      });
    }
  }

  void _submitItinerary() {
    if (_formKey.currentState!.validate()) {
      final newItinerary = Itinerary(
        name: _nameController.text,
        coverImagePath: '',
        days: List.from(_days),
      );

      setState(() {
        _itineraries.add(newItinerary);
        _nameController.clear();
        _days.clear();
      });
    }
  }

  void _showShareNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Shared! Ready to MlakuMlaku? :)',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF66B490),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildDestinationField(int dayIndex, int destinationIndex, Destination destination) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: destination.name.isEmpty ? null : destination.name,
          decoration: const InputDecoration(
            labelText: 'Destination',
            alignLabelWithHint: true,
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          dropdownColor: Colors.grey[800],
          style: const TextStyle(color: Colors.white),
          items: _places.map((place) {
            return DropdownMenuItem<String>(
              value: place.name,
              key: ValueKey(place.id),
              child: Text(
                place.name,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                _days[dayIndex].destinations[destinationIndex].name = newValue;
              });
            }
          },
          validator: (value) => value == null || value.isEmpty ? 'Please select a destination' : null,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickTime(dayIndex, destinationIndex),
          child: AbsorbPointer(
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                labelText: 'Time',
                alignLabelWithHint: true,
                hintText: '--:--',
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                suffixIcon: Icon(Icons.access_time, color: Colors.white),
              ),
              controller: destination.timeController,
              style: const TextStyle(color: Colors.white),
              validator: (value) => value!.isEmpty ? 'Please select a time' : null,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[900],
          appBar: AppBar(
            backgroundColor: Colors.grey[900],
            foregroundColor: Colors.white,
            title: const Text(
              'Create Itinerary',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Itinerary Name',
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addDay,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFDCC0D),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Add Day'),
                    ),
                    const SizedBox(height: 16),
                    if (_days.isNotEmpty) ...[
                      ..._days.asMap().entries.map((entry) {
                        final index = entry.key;
                        final day = entry.value;
                        return Card(
                          color: Colors.grey[800],
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'Day ${day.dayNumber}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () => _pickDate(index),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                        labelText: 'Date',
                                        alignLabelWithHint: true,
                                        hintText: 'dd/MM/yyyy',
                                        labelStyle: TextStyle(color: Colors.white),
                                        hintStyle: TextStyle(color: Colors.white54),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue),
                                        ),
                                        suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
                                      ),
                                      controller: day.dateController,
                                      style: const TextStyle(color: Colors.white),
                                      validator: (value) => value!.isEmpty ? 'Please select a date' : null,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...day.destinations.asMap().entries.map((destEntry) {
                                  return _buildDestinationField(
                                    index,
                                    destEntry.key,
                                    destEntry.value,
                                  );
                                }),
                                ElevatedButton(
                                  onPressed: () => _addDestination(index),
                                  child: const Text('Add Destination'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _submitItinerary,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF66B490),
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Create Itinerary'),
                      ),
                    ],
                    const SizedBox(height: 16),
                    ..._itineraries.asMap().entries.map((entry) {
                      final index = entry.key;
                      final itinerary = entry.value;
                      return Card(
                        color: const Color(0xFF66B490),
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Column(
                          children: [
                            // Title centered in the middle
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20), // Memperbesar padding
                              child: Text(
                                itinerary.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20, // Memperbesar ukuran font title
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // Buttons centered below the title
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.share, color: Colors.white),
                                  onPressed: _showShareNotification,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.white),
                                  onPressed: () => _editItinerary(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.white),
                                  onPressed: () => _deleteItinerary(index),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0), // Memperbesar padding isi
                              child: Column(
                                children: [
                                  ...itinerary.days.map((day) => Text(
                                    'Day ${day.dayNumber}: ${day.dateController.text}',
                                    style: const TextStyle(color: Colors.white),
                                  )),
                                  ...itinerary.days.expand((day) => 
                                    day.destinations.map((dest) => Text(
                                      '${dest.name} at ${dest.timeController.text}',
                                      style: const TextStyle(color: Colors.white),
                                    ))
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (var day in _days) {
      day.dateController.dispose();
      for (var destination in day.destinations) {
        destination.timeController.dispose();
      }
    }
    super.dispose();
  }
}

class Place {
  final String name;
  final String id;

  Place({
    required this.name,
    required this.id,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Place && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

class Destination {
  String name;
  TimeOfDay? time;
  TextEditingController timeController;

  Destination({
    required this.name,
    this.time,
  }) : timeController = TextEditingController();
}

class ItineraryDay {
  final int dayNumber;
  String date;
  TextEditingController dateController;
  final List<Destination> destinations;

  ItineraryDay({
    required this.dayNumber,
    required this.date,
    required this.destinations,
  }) : dateController = TextEditingController(text: date);
}

class Itinerary {
  final String name;
  final String coverImagePath;
  final List<ItineraryDay> days;

  Itinerary({
    required this.name,
    required this.coverImagePath,
    required this.days,
  });
}

Future<List<Place>> loadPlaces() async {
  try {
    final String response = await rootBundle.loadString('assets/DATASET_MLAKUMLAKU_FIX_FILLED_FORMATTED.json');
    final List<dynamic> jsonData = json.decode(response);
    
    // Convert to Set to remove duplicates, then back to List
    final Set<String> uniqueNames = <String>{};
    final List<Place> uniquePlaces = [];
    
    for (var item in jsonData) {
      final String name = item['Place Name'] as String;
      if (uniqueNames.add(name)) {  // Returns true if name was not in set
        uniquePlaces.add(Place(
          name: name,
          id: UniqueKey().toString(),
        ));
      }
    }
    
    return uniquePlaces;
  } catch (e) {
    return [];
  }
}