import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
// void main() {
//   runApp(EmojiRatingApp());
// }

class review {
  final String id;
  final String cusid;
  final String feedback;
  final String feedbackdate;

  review(
      {required this.id,
      required this.cusid,
      required this.feedback,
      required this.feedbackdate});
}

// class EmojiRatingApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: EmojiRatingPage(),
//     );
//   }
// }

class EmojiRatingPage extends StatefulWidget {
  final String ipAddress;
  EmojiRatingPage({required this.ipAddress});
  @override
  _EmojiRatingPageState createState() => _EmojiRatingPageState();
}

class _EmojiRatingPageState extends State<EmojiRatingPage> {
  List<review> reviewsList = [];
  int currentRating = 0; // Initialize with a default rating
  TextEditingController feedbackController = TextEditingController();
  String? errorMessage;

  Future<void> sendFeedback() async {
    final String url = 'http://${widget.ipAddress}/sendreviews';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('lid');

    final Map<String, String> requestBody = {
      'feedbac': feedbackController.text,
      'authToken': authToken!,
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(requestBody),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        errorMessage = null;
        final jsonData = json.decode(response.body);
        if (jsonData.containsKey("result") && jsonData["result"] != null) {
          final bookingsData = jsonData["result"] as List<dynamic>;

          setState(() {
            reviewsList = bookingsData.map((data) {
              return review(
                id: data['feedback_id']?.toString() ?? 'N/A',
                cusid: data['customer_id']?.toString() ?? 'N/A',
                feedback: data['feedback']?.toString() ?? 'N/A',
                feedbackdate: data['feedback_date'] ?? 'N/A',
              );
            }).toList();
          });
        } else {
          setState(() {
            errorMessage = 'No feedback submitted';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error submitting feedback';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        errorMessage = 'An error occurred';
      });
    }
  }

  Future<void> Ratings(int rating) async {
    final String url = 'http://${widget.ipAddress}/ratings';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('lid');

    final Map<String, dynamic> requestBody = {
      'rating': rating,
      'authToken': authToken!,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(requestBody),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Rating submitted successfully');
      } else {
        print('Error submitting rating');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 185, 132, 187), 
        centerTitle: true,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
          ],
        ),
        title: Text('Feedback'),
        actions: [
          TextButton(
              onPressed: () {
                sendFeedback();
                Fluttertoast.showToast(
                  msg: "Feedback Submitted",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Color.fromARGB(255, 185, 132, 187),
                  textColor: Colors.white,
                );
              },
              child: Text(
                "Submit",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.all(20)),
              Text(
                "What do you think of our App?",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 150,
                width: 330,
                padding: EdgeInsets.all(20), // Adjust the padding as needed
               decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 185, 132, 187), // First shade color
                  Color.fromARGB(255, 78, 91, 97),   // Second shade color
                ],
                stops: [0.3, 1.0], // Adjust the stops as needed
              ),
            ),
                child: EmojiFeedback(
                  animDuration: const Duration(milliseconds: 300),
                  curve: Curves.bounceIn,
                  inactiveElementScale: .5,
                  onChanged: (value) {
                    setState(() {
                      currentRating = value;
                    });
                    Ratings(value);
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Current Rating: $currentRating',
                style: TextStyle(fontSize: 16.0),
              ),
              Padding(padding: EdgeInsets.all(20)),
              Text(
                "What would you like to share with us?",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 330,
                height: 150,
                 decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 185, 132, 187), // First shade color
                  Color.fromARGB(255, 78, 91, 97),   // Second shade color
                ],
                stops: [0.3, 1.0], // Adjust the stops as needed
              ),
            ),
                child: Center(
                  child: TextFormField(
                    controller: feedbackController,
                    decoration: InputDecoration(
                      hintText: "Your Thoughts",
                      hintStyle: TextStyle(
                        fontSize: 18, // Adjust the font size as needed
                        color: Color.fromARGB(255, 99, 95, 95), // Adjust the color as needed
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      contentPadding: EdgeInsets.symmetric(vertical: 100),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}