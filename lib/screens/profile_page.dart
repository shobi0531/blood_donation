import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'change_pass.dart';
import 'login.dart';

class User_details extends StatefulWidget {
  const User_details({Key? key}) : super(key: key);

  @override
  State<User_details> createState() => _User_detailsState();
}

class _User_detailsState extends State<User_details> {
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
              padding: const EdgeInsets.fromLTRB(0, 200.0, 0.0, 0.0),
              child: Container(
                width: double.infinity,
                height: (MediaQuery.of(context).size.height) - 200,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30.0, 50.0, 40.0, 40.0),
                      child: Center(
                          child: Text(
                            user_name,
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          )),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(60.0, .0, 30.0, 0.0),
                              child: Icon(
                                Icons.phone_in_talk_sharp,
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Text(
                                phone,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(60.0, .0, 30.0, 0.0),
                              child: Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Text(
                                user_email,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(60.0, .0, 30.0, 0.0),
                              child: Icon(
                                Icons.date_range_outlined,
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Text(
                                formatter,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35.0, 50.0, 20.0, 35.0),
                      child: Container(
                        height: 45.0,
                        width: 200.0,
                        decoration: BoxDecoration(),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFB61F1F), // Set the background color using backgroundColor
                            shape: StadiumBorder(),
                          ),
                          child: Text(
                            'CHANGE PASSWORD',
                            style: TextStyle(
                              fontFamily: "Roboto-Bold",
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 120.0, 0.0, 0.0),
              child: Center(child: CircleAvatar(radius: 80, backgroundColor: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
