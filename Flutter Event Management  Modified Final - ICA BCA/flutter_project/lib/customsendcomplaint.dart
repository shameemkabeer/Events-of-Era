import 'package:flutter/material.dart';
// import 'package:flutter_project/admnviewcomplaint.dart';
import 'package:flutter_project/customerhome.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// void main() {
//   runApp(ComplaintForm());
// }

class complaint {
  final String id;
  final String cusid;
  final String comp;
  final String rep;
  final String date;

  complaint(
      {required this.id,
      required this.cusid,
      required this.comp,
      required this.rep,
      required this.date});
}

// class ComplaintForm extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ComplaintPage(),
//     );
//   }
// }

class ComplaintPage extends StatefulWidget {
  final String ipAddress;
  ComplaintPage({required this.ipAddress});
  @override
  _ComplaintFormState createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintPage> {
  TextEditingController complaintController = TextEditingController();
  String? errorMessage;

  Future<void> Complaints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('lid');
    String complaint = complaintController.text;

    try {
      final response = await http.post(
        Uri.parse('http://${widget.ipAddress}/sendcomp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'complaint': complaint, 'authToken': authToken!}),
      );

      if (response.statusCode == 200) {
        complaintController.clear();
        print('Complaint submitted successfully');
      } else {
        print('Error submitting complaint');
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
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => cushome()));
            },
            icon: Icon(Icons.arrow_back)),
        centerTitle: true,
        title: Text('Complaint Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: 500,
            height: 300,   
            padding: EdgeInsets.all(5),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Enter your complaint',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0)),
                ),
                TextFormField(
                  controller: complaintController,
                  maxLines: 5,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(10))),
                          backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 250, 250, 250))),
                      onPressed: () {
                        Complaints();
                      },
                      child: Text('Send Complaint',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}