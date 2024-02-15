import 'package:flutter/material.dart';
import 'package:flutter_project/home.dart';
import 'package:flutter_project/staffviewprofile.dart';
import 'package:flutter_project/staffvieweventbookings.dart';
import 'package:flutter_project/staffviewcustomevents.dart';
import 'package:flutter_project/staffviewratingandreviews.dart';
import 'package:lottie/lottie.dart';

class staffhome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: staffhom(ipAddress: '172.20.10.2:5000'),
    );
  }
}

class staffhom extends StatelessWidget {
  final String ipAddress;

  staffhom({required this.ipAddress});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Staff Home'),
        backgroundColor: Color.fromARGB(255, 190, 68, 255),
        centerTitle: true,
        // Add a drawer button to the app bar
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                // Open the drawer
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => (HomePage(
                          ipAddress: '',
                        ))),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 178, 35, 255), // First shade color
                Color.fromARGB(255, 255, 51, 235), // Second shade color
              ],
              stops: [0.20, 1.25], // Adjust the stops as needed
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Container(
                  child: CircleAvatar(
                    radius: 40, // Adjust the size of the avatar
                    backgroundImage: Image.asset(
                      'assets/flutter.png',
                      fit: BoxFit.cover,
                      width: 80, // Adjust the width of the image
                      height: 80, // Adjust the height of the image
                    ).image, // Add your avatar image
                  ),
                ),
              ),
              ListTile(
                title: Text('View Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage(ipAddress: ipAddress)),
                  );
                },
              ),
              ListTile(
                title: Text('View Event Bookings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BookingListPage(ipAddress: ipAddress)),
                  );
                },
              ),
              ListTile(
                title: Text('View Custom Events'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => stfcustomeventview(
                              ipAddress: ipAddress,
                              cuseventid: '',
                            )),
                  );
                },
              ),
              ListTile(
                title: Text('View Rating & Reviews'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RatingListPage(ipAddress: ipAddress)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 81, 238),
              Color.fromARGB(255, 218, 207, 217),
              Color.fromARGB(255, 190, 68, 255),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/staff2.json',
                width: 250,
                height: 250,
                repeat: true,
                reverse: false,
                animate: true,
                options:
                    LottieOptions(enableMergePaths: true), // Enable merge paths
              ),
              Text('Tap The Menu Button')
            ],
          ),
        ),
      ),
    );
  }
}
