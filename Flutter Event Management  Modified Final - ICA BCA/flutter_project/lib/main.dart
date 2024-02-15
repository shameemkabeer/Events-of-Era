import 'package:flutter/material.dart';
import 'package:flutter_project/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:confetti/confetti.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController? inputController;
  String? ipAddress;
  double rotationAngle = 0.0;

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    inputController = TextEditingController();
    loadIpAddress(); // Load the saved IP address from shared preferences
    _confettiController = ConfettiController();
  }

  // Function to load the IP address from shared preferences
  Future<void> loadIpAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      ipAddress = prefs.getString('ipAddress');
      if (ipAddress == null) {
        // If no IP address is saved, you can set a default value or leave it empty.
        ipAddress = '';
      }
      inputController!.text = ipAddress!;
    });
  }

  // Function to save the IP address to shared preferences
  Future<void> saveIpAddress(String ipAddress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ipAddress', ipAddress);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromRGBO(185, 132, 187, 1),
        // Color.fromARGB(223, 239, 229, 229),
        body: SingleChildScrollView(
          child: Center(
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 10,
              minBlastForce: 1,
              child: Container(
                width: 250,
                height: 700,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: inputController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(227, 255, 252, 252),
                        hintText: 'Enter Your IP Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    SizedBox(height: 20),
                    Builder(
                      builder: (context) => ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(227, 255, 252, 252)),
                        ),
                        onPressed: () {
                          saveIpAddress(
                              inputController!.text); // Save the IP address
                          _confettiController
                              .play(); // Trigger confetti animation
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Splash(),
                            ),
                          );
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
