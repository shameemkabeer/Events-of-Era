import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CustomEvent {
  final String bookingid;
  final String categoryId;
  final String customerid;
  final DateTime bookingDate;
  final String time;
  final String venue;
  final int noofpersons;
  final String status;
  final String type;

  CustomEvent({
    required this.bookingid,
    required this.categoryId,
    required this.customerid,
    required this.bookingDate,
    required this.time,
    required this.venue,
    required this.noofpersons,
    required this.status,
    required this.type,
  });
}

class BookEventPage extends StatefulWidget {
  final String ipAddress;
  BookEventPage({required this.ipAddress});
  @override
  _BookEventPageState createState() => _BookEventPageState();
}

class _BookEventPageState extends State<BookEventPage> {
  List<CustomEvent> bookEvents = [];
  List<String> categories = [];
  String? selectedCategory;
  TextEditingController bookingDateController = TextEditingController();
  TextEditingController bookingTimeController = TextEditingController();
  TextEditingController bookingVenueController = TextEditingController();
  TextEditingController numberOfPersonsController = TextEditingController();
  String? _errorMessage;
  String? selectedVenue;
  DateTime? selectedDate;
  String? selectedTimeSlot;

  List<String> availableTimeSlots = [
    '09:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '03:00 PM - 04:00 PM',
    '04:00 PM - 05:00 PM',
    '05:00 PM - 06:00 PM',
    '06:00 PM - 07:00 PM',
    '07:00 PM - 08:00 PM',
  ];

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
    'Historic Mansion',
  ];

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  Future<void> _getCategories() async {
    final String url = 'http://${widget.ipAddress}/getcategories';

    try { 
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey("message") &&
            responseData["message"] is List) {
          List<dynamic> categoryDataList = responseData["message"];
          List<String> categoriesList = [];

          for (var category in categoryDataList) {
            categoriesList.add(category['category_name']);
          }

          setState(() {
            categories = categoriesList;
          });
        } else {
          print(
              'Error: Invalid server response format - Missing "message" key or not a list');
        }
      } else {
        print('Error fetching categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String?> getCategoryID(String categoryName) async {
    final String url = 'http://${widget.ipAddress}/get_category_id';

    final Map<String, String> requestBody = {
      'category_name': categoryName,
    };

    try {
      final response = await http.post(Uri.parse(url), body: requestBody);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String categoryID = responseData['category_id'].toString();
        return categoryID;
      } else {
        print('Error fetching Booking ID: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  void _bookEvent() async {
    final String url = 'http://${widget.ipAddress}/bookevent';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('lid');
    // Fetch category_id based on selectedCategory
    String categoryID = await getCategoryID(selectedCategory!) ?? '';
    final Map<String, dynamic> requestBody = {
      'auth': categoryID,
      'authToken': authToken!,
      'date': selectedDate != null ? selectedDate!.toString() : '',
      'time': selectedTimeSlot ?? '',
      'place': selectedVenue ?? '',
      'noofpersons': numberOfPersonsController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('category_id')) {
          String bid = responseData['bid'].toString();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('bid', bid);
          print('Event booked successfully, bid: $bid');
        } else {
          print('Booking ID not found in the response');
        }

        setState(() {
          selectedDate = null;
          selectedTimeSlot = null;
          selectedVenue = null;
          selectedCategory = null;
        });
        numberOfPersonsController.clear();
        setState(() {
          _errorMessage = null;
        });
      } else {
        print('Error booking events: ${response.statusCode}');
        setState(() {
          _errorMessage = 'Error booking events';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _errorMessage = 'An error occurred';
      });
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
        backgroundColor: Color.fromARGB(255, 185, 132, 187), 
        centerTitle: true,
        title: Text('Book Events'),
      ),
      body: SingleChildScrollView(
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Select a Category:',  
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Booking Date: ${selectedDate != null ? selectedDate!.toLocal().toString().split(' ')[0] : ""}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 251, 253, 254)),
                      onPressed: () => _selectBookingDate(context),
                      child: Text('Select Date',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedTimeSlot,
                  onChanged: (value) {
                    setState(() {
                      selectedTimeSlot = value;
                    });
                  },
                  items: availableTimeSlots.map((timeSlot) {
                    return DropdownMenuItem<String>(
                      value: timeSlot,
                      child: Text(timeSlot),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Select Time Slot',
                     labelStyle: TextStyle(
                       color: Colors.black, // Set your desired color
                 ),
                  ),
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
                  controller: numberOfPersonsController,
                  decoration: InputDecoration(
                    labelText: 'Number of Persons',
                     labelStyle: TextStyle(
                       color: Colors.black, // Set your desired color
                 ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 246, 248, 248)),
                        onPressed: () {
                          _bookEvent();
                        },
                        child: Text('Book Event',style: TextStyle(color: Color.fromARGB(255, 3, 3, 3)),),
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
    );
  }
}