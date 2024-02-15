import 'package:flutter/material.dart';
import 'package:flutter_project/admnmanagecostume.dart';
import 'package:flutter_project/admnmanageventcategories.dart';
import 'package:flutter_project/admnmanageventpackages.dart';
import 'package:flutter_project/home.dart';
import 'package:flutter_project/admnmanageventeam.dart';
import 'package:flutter_project/admnmanagemakeup.dart';
import 'package:flutter_project/admnvieweventbooking.dart';
import 'package:flutter_project/admnviewcomplaint.dart';
import 'package:flutter_project/admnviewratingandreviews.dart';
import 'admnmanagefood.dart'; 
import 'admnviewcustomevents.dart';
import 'admnviewpayments.dart';
import 'package:lottie/lottie.dart';

class admhome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: admhom(ipAddress: '172.20.10.2:5000'),
    );
  }
}

class admhom extends StatelessWidget {
  final String ipAddress;

  admhom({required this.ipAddress});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 185, 132, 187),
        title: Text('Admin Home'),
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
                  builder: (context) => HomePage(
                    ipAddress: ipAddress,
                  ),
                ),
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
              Color.fromARGB(255, 255, 232, 251), // First shade color
                Color.fromARGB(255, 201, 96, 204), // Second shade color
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
                title: Text('Manage Event Team'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Eventeamanage(ipAddress: ipAddress)),
                  );
                },
              ),
              ListTile(
                title: Text('Manage Event Categories'),
                onTap: () {
                  // Handle item tap
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EventCategoryPage(ipAddress: ipAddress)),
                  );
                },
              ),
              ListTile(
                title: Text('Manage Event Foods'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EventFoodPage(ipAddress: ipAddress)),
                  );
                },
              ),
              ListTile(
                title: Text('Manage Event Packages'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventPackagePage(
                              ipAddress: ipAddress,
                            )),
                  );
                },
              ),
              ListTile(
                title: Text('Manage Contact Details Of Makeup Artists'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MakePage(
                              ipAddress: ipAddress,
                            )),
                  );
                },
              ),
              ListTile(
                title: Text('Manage Contact Details Of Costume Designers'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CostumePage(
                              ipAddress: ipAddress,
                            )),
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
                        builder: (context) => BookingListPage(
                              ipAddress: ipAddress,
                            )),
                  );
                },
              ),
              ListTile(
                title: Text('View Payments'),
                onTap: () {
                  // Handle item tap
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Paymentview(
                              ipAddress: ipAddress,
                            )),
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
                        builder: (context) => Admcustomeventview(
                              ipAddress: ipAddress,
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
                        builder: (context) => RatingListPage(
                              ipAddress: ipAddress,
                            )),
                  );
                },
              ),
              ListTile(
                title: Text('View Complaints'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ComplaintListPage(ipAddress: ipAddress)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
         decoration: BoxDecoration( 
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 252, 146, 245), Color.fromARGB(255, 107, 19, 125)],
          ),
        ),
        child: Center(  
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [   
              Lottie.asset(
                'assets/welcome.json',
                width: 200,
                height: 80,
                repeat: true, // Set to true for looping
                reverse: false, // Set to true to play the animation in reverse
                animate: true, // Set to false to freeze the animation
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
