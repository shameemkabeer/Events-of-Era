import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MakeUpArtist {
  final String name;
  final String place;
  final String email;
  final String phone;

  MakeUpArtist(
      {required this.name,
      required this.place,
      required this.email,
      required this.phone});
}

class MakeUpPage extends StatefulWidget {
  final String ipAddress;
  MakeUpPage({required this.ipAddress});

  @override
  _MakeUpPageState createState() => _MakeUpPageState();
}

class _MakeUpPageState extends State<MakeUpPage> {
  List<MakeUpArtist> makeupList = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    viewMakeup();
  }

  Future<void> viewMakeup() async {
    final String url = 'http://${widget.ipAddress}/viewmakeup';
    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        errorMessage = null;
        final jsonData = json.decode(response.body);

        if (jsonData.containsKey("res") && jsonData["res"] != null) {
          final MakeupData = jsonData["res"] as List<dynamic>;
          setState(() {
            makeupList = MakeupData.map((data) {
              return MakeUpArtist(
                name: data['name']?.toString() ?? 'N/A',
                place: data['place']?.toString() ?? 'N/A',
                email: data['email']?.toString() ?? 'N/A',
                phone: data['phone']?.toString() ?? 'N/A',
              );
            }).toList();
          });
        } else {
          setState(() {
            errorMessage = 'No makeup artists found';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error fetching makeup artists';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        errorMessage = 'An error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 185, 132, 187), 
        centerTitle: true,
        title: Text('MakeUp Artists'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MakeUpList(),
      ),
    );
  }

  Widget MakeUpList() {
    return ListView.builder(
      itemCount: makeupList.length,
      itemBuilder: (context, index) {
        final makeup = makeupList[index];
        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
             decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      gradient: LinearGradient(
        colors: [
             Color.fromARGB(255, 185, 132, 187), // First shade color
      Color.fromARGB(255, 212, 204, 204).withOpacity(0.6), // Second shade color
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
            child: ListTile(
              title: Text('Artist Name: ${makeup.name}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Place: ${makeup.place}', style: TextStyle(fontSize: 16)),
                  Text('Email: ${makeup.email}', style: TextStyle(fontSize: 16)),
                  Text('Phone: ${makeup.phone}', style: TextStyle(fontSize: 16)),
                ],
              ),
              contentPadding: EdgeInsets.all(16),
              onTap: () {},
            ),
          ),
        );
      },
    );
  }
}