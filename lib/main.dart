import 'package:blood_app_nepal/screens/login_screen.dart';
import 'package:blood_app_nepal/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BloodApp());
}

class BloodApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'blood',
      theme: ThemeData(
        primarySwatch: Colors.red,
        hintColor: Colors.pink,
      ),
      home:SplashScreen(),
    );
  }
}




