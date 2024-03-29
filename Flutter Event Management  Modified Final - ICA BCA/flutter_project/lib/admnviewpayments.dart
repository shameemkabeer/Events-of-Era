import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';

class Paymentview extends StatefulWidget {
  final String ipAddress;

  Paymentview({required this.ipAddress});

  @override
  _PaymentviewState createState() => _PaymentviewState();
}

class _PaymentviewState extends State<Paymentview> {
  List<Map<String, dynamic>> paymentList = [];

  @override
  void initState() {
    super.initState();
    _getpayment();
  }

  Future<void> _getpayment() async {
    final String url = 'http://${widget.ipAddress}/getpayment';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey("event_payment") &&
            responseData["event_payment"] is List) {
          paymentList =
              List<Map<String, dynamic>>.from(responseData["event_payment"]);

          setState(() {});
        } else {
          print(
              'Error: Invalid server response format - Missing "event_payment" key or not a list');
        }
      } else {
        print('Error fetching payments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: const Color.fromARGB(255, 10, 66, 162),
            expandedHeight: 230.0,
            floating: false,
            pinned: true,
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Transform.scale(
                scale: 1.0,
                child: Lottie.asset(
                  'assets/coi.json',
                  width: 800,
                  height: 800,
                  repeat: true,
                  reverse: false,
                  animate: true,
                  options: LottieOptions(enableMergePaths: true),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final payment = paymentList[index];
                return Padding(
                  padding: EdgeInsets.all(16),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
      Color.fromARGB(255, 252, 146, 245),
        Color.fromARGB(255, 171, 30, 199) 
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                '${payment['first_name']} ${payment['last_name']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Event Package: ${payment['package_name']}'),
                                  Text(
                                      'Event Category: ${payment['category_name']}'),
                                  Text('Amount: \$${payment['amount']}'),
                                  Text(
                                      'Payment Date: ${payment['payment_date']}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: paymentList.length,
            ),
          ),
        ],
      ),
    );
  }
}