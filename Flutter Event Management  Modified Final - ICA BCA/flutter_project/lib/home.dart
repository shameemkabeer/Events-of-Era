import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'package:flutter_project/customerreg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(
    ipAddress: '172.20.10.2:5000',
  ));
}

class MyApp extends StatelessWidget {
  final String ipAddress;

  MyApp({required this.ipAddress});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(
        ipAddress: ipAddress,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String ipAddress;

  HomePage({required this.ipAddress});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> imageUrls = [
    'assets/Star1.png',
    'assets/glass.jpeg',
    'assets/Star5.png',
    'assets/ro-transformed.jpeg',
    'assets/cake-transformed.jpeg',
    'assets/light.jpg'
  ];

  PageController _controller1 = PageController();
  Timer? _timer1;

  @override
  void initState() {
    super.initState();
    // _startAutoScroll();
  }

  // void _startAutoScroll() {
  //   _timer1 = Timer.periodic(Duration(seconds: 5), (timer) {
  //     if (_controller1.page == imageUrls.length - 1) {
  //       _controller1.animateToPage(0,
  //           duration: Duration(milliseconds: 1500), curve: Curves.easeInOut);
  //     } else {
  //       _controller1.nextPage(
  //           duration: Duration(milliseconds: 1500), curve: Curves.easeInOut);
  //     }
  //   });
  // }
   
  @override
  void dispose() {
    _timer1?.cancel();

    _controller1.dispose();
    super.dispose();
  }

  Future<String> fetchData() async {
    final response =
        await http.get(Uri.parse('http://${widget.ipAddress}'));
    if (response.statusCode == 200) {
      return response.body;
    } else { 
      throw Exception('Failed to load this page');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(preferredSize: Size.fromHeight(30.0), 
      //   child: AppBar(
      //     backgroundColor: Color.fromRGBO(199, 140, 201, 1),
      //     centerTitle: true,
      //   ),
      // ),
      body: Stack(
        children: [
          Image.asset(
            'assets/ro-transformed.jpeg',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(
                          ipAddress: widget.ipAddress,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(227, 255, 252, 252),// Background color
                    onPrimary: const Color.fromARGB(255, 0, 0, 0), // Text color
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // Button padding
                    textStyle: TextStyle(fontSize: 18), // Text style
                  ),
                  child: Text('Customer'),
                ),
                SizedBox(width: 1.5),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(
                          ipAddress: widget.ipAddress,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(227, 255, 252, 252), // Background color
                    onPrimary: const Color.fromARGB(255, 0, 0, 0), // Text color
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // Button padding
                    textStyle: TextStyle(fontSize: 18), // Text style
                  ),
                  child: Text('Sign In'),
                ),
              ],
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     children: <Widget>[
          //       Container(
          //         height: MediaQuery.of(context).size.height,
          //         width: 132,
          //         child: ListView.builder(
          //           controller: _controller1,
          //           scrollDirection: Axis.vertical,
          //           itemBuilder: (BuildContext context, int index) {
          //             return Padding(
          //               padding: const EdgeInsets.all(0),
          //               child: Image.asset(
          //                 imageUrls[index % imageUrls.length],
          //                 height: MediaQuery.of(context).size.height,
          //                 fit: BoxFit.cover,
          //               ),
          //             );
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}