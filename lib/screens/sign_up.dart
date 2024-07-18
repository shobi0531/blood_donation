import 'package:blood_app_nepal/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'login.dart';
class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  void signup() async{
    try {
      await _auth.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
        content: Text('Successfully sign uped'), duration: Duration(seconds: 2),));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>LoginScreen()),
      );
      final now = new DateTime.now();
      formatter = DateFormat('yMd').format(now);
      collRef.add({
        'Email' : _emailController.text,
        'Name' : _nameController.text,
        'Phone' : _phoneController.text,
        'Date' : formatter,
      });

      _emailController.clear();
      _passwordController.clear();
      _phoneController.clear();
      _nameController.clear();
    }
    catch(e)
    {
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
            children:[
              Container(

                height:  MediaQuery.of(context).size.height,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,200,0.0,0.0),
                child: Container(
                  width: double.infinity,
                  height: (MediaQuery.of(context).size.height)-200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0,10.0,0.0,15.0),
                        child: Center(child: Text("Welcome to",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,15.0),
                        child: Center(child: Text("Please sign up to continue",style: TextStyle(fontSize: 17,),)),
                      ),
                      Form(
                        key: formkey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(40.0,0.0,40.0,25.0),
                              child: TextFormField(
                                controller: _nameController,
                                validator: (name){
                                  if(name!.isEmpty)
                                    return "Please enter name";
                                  else if(!RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$")
                                      .hasMatch(name)){
                                    return "Please Enter first name and last name";
                                  }
                                },
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.account_circle_sharp,
                                    ),
                                    contentPadding: EdgeInsets.all(10.0,),
                                    border: OutlineInputBorder(  borderRadius: BorderRadius.circular(30.0),),
                                    labelText: 'Name',
                                    labelStyle: TextStyle(color:Colors.grey,fontWeight: FontWeight.bold),
                                    hintText: 'Enter Your Name',
                                    hintStyle: TextStyle(color:Colors.grey,fontWeight: FontWeight.bold)
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(40.0,0.0,40.0,25.0),
                              child: TextFormField(
                                controller: _emailController,
                                validator: (email){
                                  if(email!.isEmpty)
                                    return "Please enter email";
                                  else if(!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(email)){
                                    return "Please Enter a valid email";
                                  }
                                },
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email,
                                    ),
                                    contentPadding: EdgeInsets.all(10.0,),
                                    border: OutlineInputBorder(  borderRadius: BorderRadius.circular(30.0),),
                                    labelText: 'E-Mail',
                                    labelStyle: TextStyle(color:Colors.grey,fontWeight: FontWeight.bold),
                                    hintText: 'Enter Your Name',
                                    hintStyle: TextStyle(color:Colors.grey,fontWeight: FontWeight.bold)
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(40.0,0.0,40.0,25.0),
                              child: TextFormField(
                                controller: _passwordController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (password){
                                  if(password!.isEmpty){
                                    return "Please Enter the password";
                                  }
                                  else if(password.length<7)
                                    return "Please enter minimum 8 letters";
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock,
                                    ),
                                    contentPadding: EdgeInsets.all(10.0,),
                                    border: OutlineInputBorder( borderRadius: BorderRadius.circular(30.0)),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(color:Colors.grey,fontWeight: FontWeight.bold),
                                    hintText: 'Enter Password',
                                    hintStyle: TextStyle(color:Colors.grey,fontWeight: FontWeight.bold)
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(40.0,0.0,40.0,30.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _phoneController,
                                validator: (phone){
                                  if(phone!.isEmpty)
                                    return "Please enter phone number";
                                  else if(!RegExp(r"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$")
                                      .hasMatch(phone)){
                                    return "Please Enter the vaild phone number";
                                  }
                                },
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.phone,
                                    ),
                                    contentPadding: EdgeInsets.all(10.0,),
                                    border: OutlineInputBorder(  borderRadius: BorderRadius.circular(30.0),),
                                    labelText: 'Phone Number',
                                    labelStyle: TextStyle(color:Colors.grey,fontWeight: FontWeight.bold),
                                    hintText: 'Enter Your Phone Number',
                                    hintStyle: TextStyle(color:Colors.grey,fontWeight: FontWeight.bold)
                                ),
                              ),
                            ),
                            Container(
                              height: 40.0,
                              width: 300.0,
                              decoration: BoxDecoration(
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  if(formkey.currentState!.validate()){
                                    signup();
                                    Login();
                                  }


                                },
                                style: OutlinedButton.styleFrom(
                                  shape: StadiumBorder(),

                                ),

                                child: Text('SIGN UP',),

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
                padding: const EdgeInsets.fromLTRB(0,30.0,0.0,0.0),
                child: Center(
                  child: Icon(
                    Icons.manage_accounts_rounded,
                    color: Colors.white,
                    weight: 10.0,
                    size: 170.0,
                  ),
                ),

              ),

            ]
        ),
      ),



    );;
  }
}
