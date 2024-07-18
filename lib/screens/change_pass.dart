import 'package:blood_app_nepal/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> changePassword() async {
    if (formKey.currentState!.validate()) {
      try {
        await currentUser!.updatePassword(_passwordController.text);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password has been changed.'),
          duration: Duration(seconds: 2),
        ));
        _passwordController.clear();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password change failed: $e'),
          duration: Duration(seconds: 2),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFB61F1F),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 260.0, 0.0, 0.0),
              child: Container(
                width: double.infinity,
                height: (MediaQuery.of(context).size.height) - 260,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 25.0),
                      child: Center(
                        child: Text(
                          "Change Password",
                          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(00.0, 0.0, 00.0, 20.0),
                      child: Center(
                        child: Text(
                          "Please enter new password",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 30.0),
                            child: TextFormField(
                              controller: _passwordController,
                              validator: (password) {
                                if (password!.isEmpty) {
                                  return "Please enter the password";
                                } else if (password.length < 7) {
                                  return "Password must be at least 8 characters";
                                }
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,

                                ),
                                contentPadding: EdgeInsets.all(10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                                hintText: 'Enter Password',
                                hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                            height: 40.0,
                            width: 330.0,
                            decoration: BoxDecoration(),
                            child: ElevatedButton(
                              onPressed: changePassword,
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFB61F1F), // Set the background color to Color(0xFFB61F1F)
                                shape: StadiumBorder(),
                              ),

                              child: Text('CHANGE PASSWORD' ,style:  TextStyle(
                                fontFamily: "Roboto-Bold",
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 30.0, 0.0, 0.0),
                child: Icon(
                  Icons.lock_reset_outlined,
                  color: Colors.white,
                  weight: 10.0,
                  size: 200.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
