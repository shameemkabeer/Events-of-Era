import 'package:flutter/material.dart';
import 'package:flutter_project/admnviewpackages.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PaymentForm extends StatefulWidget {
  final String ipAddress;
  final String packamount;
  PaymentForm({required this.ipAddress, required this.packamount});
  @override
  _PaymentFormState createState() => _PaymentFormState(); 
}

class _PaymentFormState extends State<PaymentForm> {
  String flaskServerUrl;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;
  TextEditingController NameController = TextEditingController();
  TextEditingController NumberController = TextEditingController();
  TextEditingController DateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  String bookingStatus = '';

  _PaymentFormState() : flaskServerUrl = '';

  Future<void> makePaymentRequest(String packageAmount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authT = prefs.getString('bid');
    if (authT != null) {
      final Map<String, dynamic> requestBody = {
        'packageAmount': packageAmount,
      };

      try {
        final response = await http.post(
          Uri.parse('$flaskServerUrl/payment?authT=$authT'),
          body: jsonEncode(requestBody),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          print('paid successfully');
        } else {
          print('failed to pay');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.packamount);
    flaskServerUrl = 'http://${widget.ipAddress}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 185, 132, 187),  
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
      const Color.fromARGB(255, 207, 198, 198).withOpacity(0.0),  // Adjust the opacity (0.5 in this case)
      ],
      stops: [0.15, 1.0], // Adjust the stops as needed
      ),
    ),
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Payment Page',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    width: 700,
                    child: Card(
                      color: Colors.white,
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      shadowColor: Color.fromARGB(255, 185, 132, 187),
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 16),
                              Text(
                                "Cardholder's Name",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              TextFormField(
                                controller: NameController,
                                decoration: InputDecoration(
                                  hintText: 'John Doe',
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 219, 210, 210),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 228, 220, 220),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(255, 247, 235, 249),
                                    ),
                                  ),
                                  hintStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                                ),
                                style: TextStyle(color: Colors.purple),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Card Number',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              TextFormField(
                                controller: NumberController,
                                maxLength: 16,
                                decoration: InputDecoration(
                                  hintText: '1234 5678 9012 3456',
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 219, 210, 210),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 228, 220, 220),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 232, 220, 234),
                                    ),
                                  ),
                                  hintStyle: TextStyle(color: const Color.fromARGB(255, 255, 253, 255)),
                                ),
                                style: TextStyle(color: Colors.purple),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Expiry Date',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        TextFormField(
                                          controller: DateController,
                                          decoration: InputDecoration(
                                            hintText: 'MM/YY',
                                            filled: true,
                                            fillColor: Color.fromARGB(255, 219, 210, 210),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 228, 220, 220),
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(
                                                color: const Color.fromARGB(255, 237, 232, 237),
                                              ),
                                            ),
                                            hintStyle:
                                                TextStyle(color: const Color.fromARGB(255, 246, 245, 247)),
                                          ),
                                          style:
                                              TextStyle(color: Colors.purple),
                                          validator: (value) {
                                            final RegExp regExp =
                                                RegExp(r'^\d{2}/\d{2}$');

                                            if (!regExp.hasMatch(value!)) {
                                              return 'Invalid Date Format';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 13),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'CVV',
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.grey),
                                        ),
                                        TextFormField(
                                          controller: cvvController,
                                          maxLength: 3,
                                          decoration: InputDecoration(
                                            hintText: '123',
                                            filled: true,
                                            fillColor: Color.fromARGB(255, 219, 210, 210),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 228, 220, 220),
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(255, 238, 234, 238),
                                              ),
                                            ),
                                            hintStyle:
                                                TextStyle(color: const Color.fromARGB(255, 235, 232, 236)),
                                          ),
                                          style:
                                              TextStyle(color: Colors.purple),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Amount',
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.grey),
                                        ),
                                        TextFormField(
                                          controller: _controller,
                                          enabled: false,
                                          decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Color.fromARGB(255, 219, 210, 210), // Set the background color
                                              border: OutlineInputBorder(
                                                // Set the rectangular border
                                                borderRadius: BorderRadius.circular(
                                                    12.0), // Adjust the radius as needed
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255,
                                                        228,
                                                        220,
                                                        220)), // Set the border color
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                // Set the border when focused
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(255, 235, 232, 235)), // Set the border color
                                              ),
                                              hintStyle: TextStyle(
                                                  color: const Color.fromARGB(255, 240, 235, 241))),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.purple),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 80,
                                width: 50,
                              ),
                              Center(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(
                                        Size(500, 50)),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>( 
                                            const Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      String packageAmount = widget.packamount;
                                      makePaymentRequest(packageAmount);
                                      NameController.clear();
                                      NumberController.clear();
                                      DateController.clear();
                                      cvvController.clear();
                                      _controller.clear();
                                    }
                                  },
                                  child: Text('Pay Now',
                                      style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}