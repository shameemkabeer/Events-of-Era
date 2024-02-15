import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'customerviewcustomevents.dart';
import 'dart:convert';

class CustomEvent {
  final String customEventId;
  final String customerId;
  final String customEventTitle;
  final String budgetAmount;
  final String place;
  final String noOfPersons;
  final String customEventDate;
  final String customEventStatus;

  CustomEvent({
    required this.customEventId,
    required this.customerId,
    required this.customEventTitle,
    required this.budgetAmount,
    required this.place,
    required this.noOfPersons,
    required this.customEventDate,
    required this.customEventStatus,
  });
}

class CustomEventPage extends StatefulWidget {
  final String ipAddress;
  CustomEventPage({required this.ipAddress});

  @override
  _CustomEventPageState createState() => _CustomEventPageState();
}

class _CustomEventPageState extends State<CustomEventPage> {
  List<CustomEvent> customEvents = [];
  List<String> foods = [];
  String? selectedFood;

  TextEditingController titleController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController personsController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  String? _errorMessage;
  String? selectedVenue;
  DateTime? selectedDate;

  List<String> availableplaces = [
    'Conference Center',
    'Hotel Ballroom',
    'Outdoor Park',
    'Auditorium',
    'Banquet Hall',
    'Community Center',
    'Convention Center',
    'Restaurant',
    'Rooftop Terrace',
    'Beach Resort',
    'Country Club',
    'Sports Stadium',
    'Art Gallery',
    'Theater',
    'Wedding Chapel',
    'Museum',
    'Vineyard',
    'Yacht Club',
    'Farm or Barn',
    'Botanical Garden',
    'Historic Mansion'
  ];

  @override
  void initState() {
    super.initState();
    _getFoods();
  }

  Future<void> _getFoods() async {
    final String url = 'http://${widget.ipAddress}/getfoods';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey("message") &&
            responseData["message"] is List) {
          List<dynamic> foodDataList = responseData["message"];
          List<String> foodsList = [];

          for (var food in foodDataList) {
            foodsList.add(food['food_name']);
          }

          setState(() {
            foods = foodsList;
          });
        } else {
          print(
              'Error: Invalid server response format - Missing "message" key or not a list');
        }
      } else {
        print('Error fetching foods: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String?> getFoodID(String foodName) async {
    final String url = 'http://${widget.ipAddress}/get_food_id';

    final Map<String, String> requestBody = {
      'food_name': foodName,
    };

    try {
      final response = await http.post(Uri.parse(url), body: requestBody);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String foodID = responseData['food_id'].toString();
        return foodID;
      } else {
        print('Error fetching food ID: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> _selectBookingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(   
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(   
         backgroundColor:  Color.fromARGB(255, 185, 132, 187), 
        centerTitle: true,
        title: Text('Manage Custom Events'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
            gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
       colors: [
      Color.fromARGB(255, 185, 132, 187), // First shade color
      Colors.black.withOpacity(0.0),  // Adjust the opacity (0.5 in this case)
      ],
      stops: [0.15, 1.0], // Adjust the stops as needed
      ),
    ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Event Title',
                      labelStyle: TextStyle(
                       color: Colors.black, // Set your desired color
                 ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Select a Food:',
                    style: TextStyle(fontSize: 16),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedFood,
                    onChanged: (String? newValue) async {
                      setState(() {
                        selectedFood = newValue;
                      });
                      String? foodID = await getFoodID(newValue!);
                      if (foodID != null) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('foodid', foodID);
                      }
                    },
                    items: foods.map((String food) {
                      return DropdownMenuItem<String>(
                        value: food,
                        child: Text(food),
                      );
                    }).toList(),
                  ),
                  TextField(
                    controller: budgetController,
                    decoration: InputDecoration(
                      labelText: 'Budget Amount',
                       labelStyle: TextStyle(
                       color: Colors.black, // Set your desired color
                 ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Booking Date: ${selectedDate != null ? selectedDate!.toLocal().toString().split(' ')[0] : ''}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                         style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 253, 255, 255)),
                        onPressed: () => _selectBookingDate(context),
                        child: Text('Select Date',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                      ),
                    ],
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedVenue,
                    onChanged: (value) {
                      setState(() {
                        selectedVenue = value;
                      });
                    },
                    items: availableplaces.map((venue) {
                      return DropdownMenuItem<String>(
                        value: venue,
                        child: Text(venue),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Select Booking Venue',
                        labelStyle: TextStyle(
                       color: Colors.black, // Set your desired color
                 ),
                    ),
                  ),
                  TextField(
                    controller: personsController,
                    decoration: InputDecoration(
                      labelText: 'Number of Persons',
                        labelStyle: TextStyle(
                       color: Colors.black, // Set your desired color
                 ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 254, 255, 255)),
                          onPressed: () {
                            _addCustomEvent();
                          },
                          child: Text('Add',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                        ),
                        ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 250, 253, 255)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Customeventview(
                                        ipAddress: widget.ipAddress,
                                      )),
                            );
                          },
                          child: Text('View',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                        ),
                      ],
                    ),
                  ),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addCustomEvent() async {
    final String url = 'http://${widget.ipAddress}/addcustomevent';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('lid');
    String? foodID = prefs.getString('foodid');
    print(foodID);

    final Map<String, String> requestBody = {
      'customeventname': titleController.text,
      'budget_amt': double.parse(budgetController.text).toString(),
      'place': selectedVenue ?? '',
      'noofpersons': personsController.text,
      'authToken': authToken.toString(),
      'foodid': foodID.toString(),
      'date': selectedDate != null ? selectedDate.toString() : '',
    };

    try {
      final response = await http.post(Uri.parse(url), body: requestBody);

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('cuseventid')) {
          String cuseventid = responseData['cuseventid'].toString();
          prefs.setString('cuseventid', cuseventid);

          print(
              'Custom events added successfully, Custom event ID: $cuseventid');
          titleController.clear();
          budgetController.clear();
          selectedVenue = null;
          personsController.clear();
          selectedDate = null;
          setState(() {
            _errorMessage = null;
          });
        } else {
          print('Error adding custom events: Invalid response');
          setState(() {
            _errorMessage = 'An error occurred';
          });
        }
      } else {
        print('Error adding custom events: ${response.statusCode}');
        setState(() {
          _errorMessage = 'Error adding custom events';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _errorMessage = 'An error occurred';
      });
    }
  }
}