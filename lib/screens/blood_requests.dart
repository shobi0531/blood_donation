import 'package:blood_app_nepal/model/donor.dart';
import 'package:blood_app_nepal/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestBlood extends StatefulWidget {


  @override
  _RequestBloodState createState() => _RequestBloodState();
}

class _RequestBloodState extends State<RequestBlood> {
  final bloodRequestRef = FirebaseFirestore.instance.collection('request');
  bool isRequesting = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController bloodNeedDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getLocationPermission();
  }

  Future<void> _getLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark placemark = placemarks[0];
      String completeAddress = '${placemark.locality}, ${placemark.administrativeArea}';
      setState(() {
        addressController.text = completeAddress;
      });
    } catch (e) {
      print("Error getting user location: $e");
    }
  }

  Future<void> requestBlood() async {
    try {
      String uuid = Uuid().v4();
      await bloodRequestRef.doc(uuid).set({
        "Name": nameController.text,
        "location": addressController.text,
        "bloodGroup": bloodGroupController.text,
        "phoneNumber": phoneNumberController.text,
        "bloodAmount": amountController.text,
        "bloodNeededDate": bloodNeedDateController.text,
      });
      print("Blood request successfully submitted");
    } catch (e) {
      print("Error requesting blood: $e");
    }
  }

  void handleBloodRequest() async {
    setState(() {
      isRequesting = true;
    });

    await requestBlood();

    setState(() {
      isRequesting = false;
      Navigator.pop(context);
    });
  }

  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (date != null) {
      setState(() {
        bloodNeedDateController.text = "${date.year}-${date.month}-${date.day}";
      });
    }
  }

  Future<void> openGoogleMaps() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      double latitude = position.latitude;
      double longitude = position.longitude;

      String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
      if (await canLaunch(googleMapsUrl)) {
        await launch(googleMapsUrl);
      } else {
        print("Could not open the map");
      }
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Request Blood",
          style: TextStyle(
            fontFamily: "Roboto-Bold",
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.red[900],
      ),
      body: Builder(builder: (context) {
        return isRequesting
            ? circularLoading()
            : SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFFB61F1F),
                            width: 4.0,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundImage: AssetImage("assets/img/blood6.png"),
                        ),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 4.0),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Name",
                        ),
                        controller: nameController,
                      ),
                      SizedBox(height: 10.0),
                      SizedBox(height: 15.0),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Donor needs your Location';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 4.0),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Your Location",
                        ),
                        controller: addressController,
                        onTap: () {
                          _getUserLocation();
                        },
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.location_on, color: Colors.red),
                            onPressed: () {
                              _getUserLocation();
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              _getUserLocation();
                              openGoogleMaps();
                            },
                            child: Text(
                              "Use my current location",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        keyboardType: TextInputType.numberWithOptions(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Blood Amount is Required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2.0),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Blood Amount",
                          items: [
                            DropdownMenuItem(
                              child: Text("A+"),
                              value: "A+",
                            ),
                            DropdownMenuItem(
                              child: Text("B+"),
                              value: "B+",
                            ),
                            DropdownMenuItem(
                              child: Text("O+"),
                              value: "O+",
                            ),
                            DropdownMenuItem(
                              child: Text("AB+"),
                              value: "AB+",
                            ),
                            DropdownMenuItem(
                              child: Text("A-"),
                              value: "A-",
                            ),
                            DropdownMenuItem(
                              child: Text("B-"),
                              value: "B-",
                            ),
                            DropdownMenuItem(
                              child: Text("O-"),
                              value: "O-",
                            ),
                            DropdownMenuItem(
                              child: Text("AB-"),
                              value: "AB-",
                            ),
                          ],
                        ),
                        ),
                        controller: amountController,
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        keyboardType: TextInputType.numberWithOptions(),
                        validator: (value) {
                          if (value!.isEmpty || value.length != 10) {
                            return 'Provide 10 Digit Number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 4.0),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Phone Number",
                        ),
                        controller: phoneNumberController,
                      ),
                      SizedBox(height: 10.0),
                      DropdownButtonFormField(
                        validator: (value) =>
                        value == null ? 'Please provide Blood Group' : null,
                        onChanged: (val) {
                          bloodGroupController.text = val.toString();
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 4.0),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Blood Group",
                        ),
                        hint: Text("Blood Group"),
                        items: [
                          DropdownMenuItem(
                            child: Text("A+"),
                            value: "A+",
                          ),
                          DropdownMenuItem(
                            child: Text("B+"),
                            value: "B+",
                          ),
                          DropdownMenuItem(
                            child: Text("O+"),
                            value: "O+",
                          ),
                          DropdownMenuItem(
                            child: Text("AB+"),
                            value: "AB+",
                          ),
                          DropdownMenuItem(
                            child: Text("A-"),
                            value: "A-",
                          ),
                          DropdownMenuItem(
                            child: Text("B-"),
                            value: "B-",
                          ),
                          DropdownMenuItem(
                            child: Text("O-"),
                            value: "O-",
                          ),
                          DropdownMenuItem(
                            child: Text("AB-"),
                            value: "AB-",
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        onTap: () {
                          pickDate();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Provide Date';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 4.0),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "when do you need ",
                        ),
                        controller: bloodNeedDateController,
                      ),
                      SizedBox(height: 10.0),
                      SizedBox(height: 30.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB61F1F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                        ),
                        child: Text(
                          "Request Blood",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Roboto-Bold",
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Processing Data')),
                            );
                            handleBloodRequest();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
