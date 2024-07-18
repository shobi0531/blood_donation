import 'package:blood_app_nepal/screens/blood_request_page.dart';
import 'package:blood_app_nepal/screens/drawer.dart';
import 'package:blood_app_nepal/screens/loading.dart';
import 'package:blood_app_nepal/screens/blood_requests.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:blood_app_nepal/screens/donor_list.dart';
import '../model/donor.dart';
import 'edit_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

Future<String?> getPhoneNumberFromFirebase(String documentId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('donor')
        .doc(documentId) // Use the provided document ID
        .get();

    if (snapshot.exists) {
      return snapshot.data()?['phonenumber'] as String?; // Update to use 'phonenumber' field
    } else {
      // Handle the case where the document doesn't exist
      return null;
    }
  } catch (e) {
    // Handle any errors that may occur during the process
    print('Error retrieving phone number: $e');
    return null;
  }
}

void _launchPhoneCall(String documentId) async {
  try {
    String? phoneNumber = await getPhoneNumberFromFirebase(documentId);

    if (phoneNumber != null) {
      String formattedPhoneNumber = 'tel:${Uri.encodeComponent(phoneNumber)}';

      if (await canLaunch(formattedPhoneNumber)) {
        await launch(formattedPhoneNumber);
      } else {
        print('Could not launch $formattedPhoneNumber');
      }
    } else {
      print('Phone number not available for document ID: $documentId');
    }
  } catch (e) {
    print('Error launching phone call: $e');
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final donorRef = FirebaseFirestore.instance.collection('donor');
  List<ShowDonors> allDonors = [];
  bool wannaSearch = false;

  TextEditingController userBloodQuery = TextEditingController();
  TextEditingController userLocationQuery = TextEditingController();

  List<dynamic> donors = [];

  @override
  void initState() {
    super.initState();

    // For demonstration purposes, let's consider the user is already authenticated.
    // You should replace this logic with your actual authentication logic.

    // Assuming the user is authenticated, let's create a dummy user.
    // You should replace this with your actual user creation logic.

    showDonors(context);
  }

  bool isAuth = true; // Skip authentication for now.

  // Skip login and proceed to the next screen directly.
  void skipLogin() {
    setState(() {
      isAuth = true;
    });
  }

  Future<void> getUserLocation1() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show a dialog to enable it
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Services Disabled'),
            content: Text('Please enable location services to use this feature.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Location permission is still denied, show a dialog
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Location Permission Denied'),
              content: Text('Please grant location permission to use this feature.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }

    // Get the user's current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.lowest,
    );

    // Reverse geocoding to get the address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark placemark = placemarks[0];
    String completeAddress = '${placemark.locality}';

    // Update the location text field
    if (mounted) {
      setState(() {
        userLocationQuery.text = completeAddress;
      });
    }
  }
  void showDonors(BuildContext context) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await donorRef.get();

    setState(() {
      allDonors = snapshot.docs.map((doc) => ShowDonors.fromDocument(doc)).toList();
    });
  }
  Widget showSearchResults() {
    List<ShowDonors> filteredDonors = allDonors
        .where((donor) =>
    donor.location.toLowerCase().contains(userLocationQuery.text.toLowerCase()) &&
        donor.bloodGroup == userBloodQuery.text)
        .toList();

    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          filteredDonors.isEmpty
              ? Text("No Donors Found")
              : Column(
            children: filteredDonors,
          ),
        ],
      ),
    );
  }



  Scaffold unAuthScreen() {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 35.0, right: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 6.0),
                child: Text(
                  "Donate Blood or Find Donor!",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto-Bold",
                      fontSize: 20.0),
                ),
              ),
              Container(
                color: Color(0xFFFFD3D9),
                padding: EdgeInsets.only(top: 30.0, bottom: 50.0),
                child: Image.asset(
                  'assets/img/blood6.png',
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
              ),
              Container(
                color: Color(0xFFFFD3D9),
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: skipLogin,
                  child: Text(
                    "Skip Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Roboto-Bold",
                        fontSize: 20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Future<void> openGoogleMaps1() async {
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
  Scaffold authScreen() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Dashboard", style: TextStyle(
          color: Colors.white,
          fontFamily: "Roboto-Bold",
          fontSize: 25,// Set the color to white
        ),),
        iconTheme: IconThemeData(
          color: Colors.white,),

        backgroundColor: Color(0xFFB61F1F),
      ),
      drawer: MainDrawer(), // You may need to pass the necessary parameters here.
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              color: Colors.white,
              // Add a red color border to the container
              shape: RoundedRectangleBorder(

                borderRadius: BorderRadius.circular(50.0),
                side: BorderSide(color: Color(0xFFB61F1F),width: 1.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      // Set background color to pure white
                      child: Text(
                        "Find a Donor",
                        style: TextStyle(
                          fontFamily: "",
                          fontSize: 22.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 1.0, bottom: 1.0),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      controller: userLocationQuery,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(Icons.my_location),
                            onPressed: getUserLocation1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintText: "Location ...",


                      ),
                    ),

                  ),

                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.location_on, color: Colors.red),
                        onPressed: () {
                          getUserLocation1();
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          getUserLocation1();
                          openGoogleMaps1();
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
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 1.0, bottom: 10.0),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(

                          suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  wannaSearch = false;
                                  userLocationQuery.clear();
                                  userBloodQuery.clear();
                                  FocusScope.of(context).unfocus();
                                });
                              }),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          )),
                      hint: Text("Choose Blood Group"),
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
                      onChanged: (val) {
                        setState(() {
                          userBloodQuery.text = val as String;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5.0,

                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              wannaSearch = true;
                              FocusScope.of(context).unfocus();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFB61F1F),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25), // Set the border radius to 0 for a rectangle shape
                            ),
                          ),
                          child: Text(
                            "Search",
                            style: TextStyle(
                              fontFamily: "Roboto-Bold",
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, bottom: 10.0, right: 20.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Donor_list()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFB61F1F),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25), // Set the border radius to 0 for a rectangle shape
                            ),
                          ),
                          child: Text(
                            "Be Donor",
                            style: TextStyle(
                              fontFamily: "Roboto-Bold",
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            "  Recent Donors",
            style: TextStyle(
                fontFamily: "Roboto-Bold", fontSize: 22.0, color: Colors.black),
          ),
          SizedBox(
            height: 10.0,
          ),
          wannaSearch
              ? showSearchResults()
              : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: donorRef
                .where("bloodGroup", isGreaterThan: "")
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return circularLoading();
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              List<ShowDonors> allDonors = [];
              snapshot.data?.docs.forEach((doc) {
                allDonors.add(ShowDonors.fromDocument(doc));
              });

              return SingleChildScrollView(

                child: Column(
                  children: allDonors,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFB61F1F),
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RequestBlood()));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? authScreen() : unAuthScreen();
  }
}

class ShowDonors extends StatelessWidget {
  final String displayName;
  final String location;
  final String bloodGroup;
  final String gender;
  final String phoneNumber;
  final String documentId;

  ShowDonors({
    required this.displayName,
    required this.location,
    required this.phoneNumber,
    required this.bloodGroup,
    required this.gender,

    required this.documentId,
  });

  factory ShowDonors.fromDocument(DocumentSnapshot doc) {
    return ShowDonors(
      displayName: doc['displayName'],
      location: doc['location'],
      bloodGroup: doc['bloodGroup'],
      phoneNumber: doc['phoneNumber'],
      gender: doc['gender'],
      documentId: doc.id,
    );
  }



  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0.0),
        ),
        padding: EdgeInsets.all(10.0),

        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: 120.0,
                width: 100.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFB61F1F),
                            width: 4.0,
                          ),
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          location,
                          style: TextStyle(
                            fontFamily: "Roboto-Bold",
                            color: Color(0xFFB61F1F),
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        color: Color(0xFFB61F1F),
                        child: Text(
                          bloodGroup,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Roboto-Bold",
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      displayName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontFamily: "Roboto-Bold",
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.person_pin, color: Colors.redAccent),
                            SizedBox(width: 8.0),
                            Text(
                              "$gender",
                              style: TextStyle(
                                color: Colors.black, // Text color
                                fontFamily: "Roboto-Bold",
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Icon(Icons.message, color: Colors.redAccent),
                            SizedBox(width: 8.0),
                            ElevatedButton(
                              onPressed: () async {
                                final _text = 'sms:$phoneNumber';
                                if (await canLaunch(_text)) {
                                  await launch(_text);
                                }
                              },
                              style: ButtonStyle(
                                 // Set background color to white
                                shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0), // Adjust border radius as needed
                                  ),
                                ),
                                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                              ),
                              child: Text(
                                "Message",
                                style: TextStyle(
                                  color: Colors.black, // Text color
                                  fontFamily: "Roboto-Bold",
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 1.0),

                        Row(
                          children: <Widget>[
                            Icon(Icons.phone, color: Colors.blue),
                            SizedBox(width: 0.0), // Adjusted SizedBox width
                            TextButton(
                              onPressed: () {
                                _launchPhoneCall(documentId);
                                FlutterPhoneDirectCaller.callNumber('$phoneNumber');
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                              ),
                              child: Text(
                                "Call", // Display "Call" instead of phoneNumber
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Roboto-Bold",
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),



                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
