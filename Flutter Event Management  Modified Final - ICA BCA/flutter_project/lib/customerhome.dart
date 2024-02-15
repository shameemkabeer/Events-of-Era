import 'package:flutter/material.dart';
import 'package:flutter_project/home.dart';
import 'package:flutter_project/customvieweventcategories.dart';
import 'package:flutter_project/customvieweventpackages.dart';
import 'package:flutter_project/custombookingevent.dart';
import 'package:flutter_project/customermanagecustomevent.dart';
import 'package:flutter_project/customviewmakeup.dart';
import 'package:flutter_project/customviewcostumedesigners.dart';
import 'package:flutter_project/customviewbookingdetails.dart';
import 'package:flutter_project/customsendratingandreviews.dart';
import 'package:flutter_project/customsendcomplaint.dart';
import 'package:flutter_project/customviewreply.dart';
import 'cusviewsendproposal.dart';

class cushome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: custhome(ipAddress: '172.20.10.2:5000'),
    );
  }
}

class custhome extends StatelessWidget {
  final String ipAddress;

  custhome({required this.ipAddress});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:  Color.fromARGB(255, 185, 132, 187),
        centerTitle: true,
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
                    builder: (context) => (MyApp(
                          ipAddress: '',
                        ))),
              );
            },
          ),
        ],
        title: Text('Customer Home'),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color.fromARGB(255, 249, 249, 249), // First shade color
                Color.fromARGB(255, 181, 44, 215), // Second shade color
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
                title: Text('View Event Categories'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CustomerEventCategoryPage(ipAddress: ipAddress)),
                  ); // Close the drawer
                },
              ),
              ListTile(
                title: Text('View Event Packages'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CustomerEventPackagePage(ipAddress: ipAddress)),
                  ); // Close the drawer
                },
              ),
              ListTile(
                title: Text('Manage A Custom Event'),
                onTap: () {
                  // Handle item tap
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CustomEventPage(ipAddress: ipAddress)),
                  );
                },
              ),
              ListTile(
                title: Text('View Proposals'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProposalListPage(
                            ipAddress: ipAddress, cuseventid: '')),
                  );
                },
              ),
              ListTile(
                title: Text('Book An Event'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BookEventPage(ipAddress: ipAddress)),
                  );
                },
              ),
              ListTile(
                  title: Text('View Booking Details'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BookingListPage(ipAddress: ipAddress)),
                    );
                  }),
              ListTile(
                title: Text('Send Rating & Reviews'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EmojiRatingPage(ipAddress: ipAddress)),
                  );
                },
              ),
              ListTile(
                title: Text('View Contact Details Of MakeUp Artists'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MakeUpPage(ipAddress: ipAddress)),
                  );
                },
              ),
              ListTile(
                title: Text('View Contact Details Of Costume Designers'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CostumePage(ipAddress: ipAddress)),
                  );
                },
              ),
              ListTile(
                title: Text('Send Complaint'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ComplaintPage(ipAddress: ipAddress)),
                  );
                },
              ),
              ListTile(
                title: Text('View Replies'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ReplyListPage(ipAddress: ipAddress)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
         fit: StackFit.expand,
        children:[
          Image.asset( 'assets/cushome.png',
          height: 190,),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Image.asset(
                'assets/cus.png', // Adjust the width as needed
                height: 150, // Adjust the height as needed
              ),
              Text('Tap The Menu Button'),
            ],
          ),
        ),
        ],
      ),
    );
  }
}
  