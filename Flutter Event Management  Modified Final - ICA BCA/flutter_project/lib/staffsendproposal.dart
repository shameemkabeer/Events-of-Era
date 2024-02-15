import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class proposal {
  final String proposalid;
  final String cuseventId;
  final DateTime Date;
  final int amount;
  final String status;

  proposal(
      {required this.proposalid,
      required this.cuseventId,
      required this.Date,
      required this.amount,
      required this.status});
}

class ProposalPage extends StatefulWidget {
  final String ipAddress;
  final String cuseventid;

  ProposalPage({
    required this.ipAddress,
    required this.cuseventid,
  });
  @override
  _ProposalPageState createState() => _ProposalPageState();
}

class _ProposalPageState extends State<ProposalPage> {
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String? _errorMessage;
  DateTime? selectedDate;

  void _sendProposal() async {
    if (widget.cuseventid != null) {
      final String url = 'http://${widget.ipAddress}/sendproposal';

      final Map<String, dynamic> requestBody = {
        'cuseventid': widget.cuseventid,
        'date': selectedDate != null ? selectedDate!.toString() : '',
        'amount': amountController.text,
      };

      try {
        final response = await http.post(
          Uri.parse(url),
          body: jsonEncode(requestBody),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          setState(() {
            dateController.clear();
            amountController.clear();
            _errorMessage = null;
          });
        } else {
          print('Error sending proposal: ${response.statusCode}');
          setState(() {
            _errorMessage = 'Error sending proposal';
          });
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _errorMessage = 'An error occurred';
        });
      }
    } else {
      print('custeventid is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Color.fromARGB(255, 252, 146, 245),
        centerTitle: true,
        title: Text('Send Proposal'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 252, 146, 245),
        Color.fromARGB(255, 171, 30, 199) ],
          ),
        ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                           style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 254, 254, 255),
                                    ),
                          onPressed: () {
                            _sendProposal();
                          },
                          child: Text('Send Proposal',style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1)),),
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
}