import 'package:blood_app_nepal/screens/profile_input_screen.dart';
import 'package:blood_app_nepal/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:blood_app_nepal/screens/login_screen.dart';
import 'package:blood_app_nepal/screens/forget_password.dart';
import 'package:blood_app_nepal/screens/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:ui';
CollectionReference collRef = FirebaseFirestore.instance.collection('Users');
var user_email = "email", user_name = "Username", phone = "00000 000000";
var formatter = "May 21,1990";

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  void signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = googleSignIn.currentUser;

      if (googleSignInAccount == null) {
        googleSignInAccount = await googleSignIn.signIn();
      }

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);

        final User? user = authResult.user;

        // Check if user exists in Firestore
        if (user != null) {
          final DocumentSnapshot<Map<String, dynamic>> userData =
          await collRef.doc(user.uid).get() as DocumentSnapshot<Map<String, dynamic>>;

          if (userData.exists) {
            // User already exists, navigate to the appropriate screen (e.g., HomeScreen)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Logged in with Google'),
              duration: Duration(seconds: 2),
            ));
          } else {
            // User does not exist, navigate to the profile input screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileInputScreen()),
            );

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Signed up with Google, please complete your profile'),
              duration: Duration(seconds: 2),
            ));
          }
        }
      } else {
        // User canceled Google Sign-In
        return;
      }
    } catch (e) {
      print("Error signing in with Google: $e");
    }
  }

  void signin() async {
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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 330, 0.0, 0.0),
              child: Container(
                height: (MediaQuery.of(context).size.height) - 20,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFB61F1F),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(-50),
                    topRight: Radius.circular(-50),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0),
                      child: Center(
                          child: Text(
                            "Blood Donation",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold,color: Colors.white),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                      child: Center(
                          child: Text(
                            "Please login to continue",
                            style: TextStyle(fontSize: 17,color: Colors.white),
                          )),
                    ),
                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 25.0),
                            child: TextFormField(
                              controller: _emailController,
                              validator: (email) {
                                if (email!.isEmpty)
                                  return "Please enter email";
                                else if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(email)) {
                                  return "Please Enter a valid email";
                                }
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                  contentPadding: EdgeInsets.all(10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  labelText: 'E-Mail',
                                  labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  hintText: 'Enter Your Email',
                                  hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 10.0),
                            child: Builder(
                              builder: (context) => TextFormField(
                                controller: _passwordController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (password) {
                                  if (password!.isEmpty) {
                                    return "Please Enter the password";
                                  } else if (password.length < 8) {
                                    return "Please enter minimum 8 letters";
                                  }
                                  return null; // Return null when validation succeeds
                                },
                                obscureText: true,
                                style: TextStyle(color: Colors.white), // Set text color to white
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                  contentPadding: EdgeInsets.all(10.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0)
                                  ),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                  hintText: 'Enter Password',
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Signup()),
                                    );
                                  },
                                  child: const Text(
                                    'Create new account',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 40.0,
                            width: 300.0,
                            decoration: BoxDecoration(
                              // Add any additional styling for the container
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  signin();
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                shape: StadiumBorder(),
                              ),
                              child: Text('LOGIN'),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ForgetPass()),
                                    );
                                  },
                                  child: const Text(
                                    'Forget your password?',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Login with Google'),
                                      duration: Duration(seconds: 2)
                                  )
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(50.0, 0.0, 45.0, 0.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white), // Change border color to white
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/img/g_logo.png',
                                        height: 50,
                                        width: 50,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Sign in with Google",
                                        style: TextStyle(fontSize: 23),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0.0),
              child: Container(
                width: double.infinity,
                height: (MediaQuery.of(context).size.height) - 700,
                decoration: BoxDecoration(
                    color: Color(0xFFB61F1F),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(200),
                        bottomRight: Radius.circular(200))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 140.0, 0.0, 0.0),
              child: Center(
                child: CircleAvatar(
                  radius: 45.0,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/img/blood6.png',
                      width: 90.0,
                      height: 90.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}