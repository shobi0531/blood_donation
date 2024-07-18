import 'package:flutter/material.dart';
import 'package:blood_app_nepal/screens/about.dart';
import 'package:blood_app_nepal/screens/blood_request_page.dart';
import 'package:blood_app_nepal/screens/login.dart';
import 'package:blood_app_nepal/screens/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:blood_app_nepal/screens/login.dart'; // Import your Login screen file

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  Color labelColor = Colors.white;
  double labelSize = 18.0;
  bool isHovered = false;




  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFFB61F1F),
                    width: 2.0,
                  ),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/img/blood6.png'),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Color(0xFFB61F1F),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    buildListTile('Welcome', Icons.home),
                    buildListTile('Profile', Icons.account_circle),
                    buildListTile('Blood Requests', Icons.comment),
                    buildListTile('About Us', Icons.help),
                    buildListTile('Sign Out', Icons.signpost_outlined),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListTile(String title, IconData icon) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        if (title == 'Sign Out') {
          _showSignOutConfirmation();
        } else {
          _navigateToScreen(title);
        }
      },
      onHover: (hover) {
        setState(() {
          isHovered = hover;
        });
      },
      child: Container(
        color: isHovered ? Colors.grey : Colors.transparent,
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              color: isHovered ? Colors.black : labelColor,
              fontFamily: "Roboto-Bold",
              fontSize: labelSize + 2.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Icon(icon, color: isHovered ? Colors.black : labelColor),
        ),
      ),
    );
  }

  Future<void> _showSignOutConfirmation() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Out'),
          content: Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {

                await signOutFromGoogle(); // Sign out from Google
                await FirebaseAuth.instance.signOut(); // Sign out from Firebase
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
  Future<void> signOutFromGoogle() async {
    await GoogleSignIn().signOut();
  }


  Future<void> _googleSignOut() async {
    try {
      await GoogleSignIn().signOut();
      print("Google Sign Out Successful");
    } catch (e) {
      print("Error signing out from Google: $e");
    }
  }

  void _firebaseSignOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login screen after signing out
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
      print("Firebase Sign Out Successful");
    } catch (e) {
      print("Error signing out from Firebase: $e");
    }
  }


  void _navigateToScreen(String title) {
    switch (title) {
      case 'Welcome':
      // Handle 'Welcome' click
        break;
      case 'Profile':
        Navigator.push(context, MaterialPageRoute(builder: (context) => User_details()));
        break;
      case 'Blood Requests':
        Navigator.push(context, MaterialPageRoute(builder: (context) => ShowRequest()));
        break;
      case 'About Us':
        Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUs()));
        break;
    }
  }
}
