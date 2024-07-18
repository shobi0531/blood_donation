// profile_input_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:blood_app_nepal/screens/login_screen.dart';
import 'package:blood_app_nepal/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ProfileInputScreen extends StatefulWidget {
  const ProfileInputScreen({Key? key}) : super(key: key);

  @override
  _ProfileInputScreenState createState() => _ProfileInputScreenState();
}

class _ProfileInputScreenState extends State<ProfileInputScreen> {

  CollectionReference collRef = FirebaseFirestore.instance.collection('Users');
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void signin1() async {
    try {
      final User? user = (await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text))
          .user;
      if (user?.email == _emailController.text) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Logging in'),
          duration: Duration(seconds: 2),
        ));
        print(user?.uid);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );

        FirebaseFirestore.instance
            .collection('Users')
            .where('Email', isEqualTo: _emailController.text)
            .snapshots()
            .listen((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            Map<String, dynamic> userData =
            doc.data() as Map<String, dynamic>;
            user_name = userData['Name'];
            user_email = userData['Email'];
            phone = userData['Phone'];
            formatter = userData['Date']; // Process userData
          });
        });

        print("hello");

        _emailController.clear();
        _passwordController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid email'),
        duration: Duration(seconds: 2),
      ));
      print("INVALID");
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save user profile information to Firestore
                // For example, using the collRef collection
                if (formkey.currentState!.validate()) {
                  signin1();
                }
                // Navigate back to the login scree
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
