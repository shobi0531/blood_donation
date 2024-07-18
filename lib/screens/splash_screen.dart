import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blood_app_nepal/screens/login.dart';
import 'package:blood_app_nepal/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 1),
          () => checkAuthentication(),
    );
  }

  void checkAuthentication() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      // If the user is already authenticated, navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => Login(),
        ),
      );
    } else {
      // If the user is not authenticated, navigate to the login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => Login(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/img/blood6.png', width: 200.0),
      ),
    );
  }
}
