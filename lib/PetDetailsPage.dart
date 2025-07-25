import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PetDetailsPage extends StatefulWidget {
  @override
  _PetDetailsPageState createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref("pets");

  Map<String, dynamic> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      // Get the current user's UID
      User? user = _auth.currentUser;
      if (user != null) {
        String uid = user.uid;

        // Retrieve data from Firebase Realtime Database
        DatabaseEvent event = await _database.child('$uid').once();

        if (event.snapshot.exists) {
          setState(() {
            userData = Map<String, dynamic>.from(event.snapshot.value as Map);
            isLoading = false;
          });
        } else {
          print('No data found for this user.');
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }



  String Joined = "01/06/2022";


  void _editPetDetails() {
    // Implement logic for editing pet's details
  }

  void _editOwnerDetails() {
    // Implement logic for editing owner's details
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              color: Colors.white,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button and Logo Section
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // Go back
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                            width: 12), // Spacing between back button and logo
                        Image.asset(
                          'assets/image/logo.png', // Logo image asset
                          height: 80,
                          width: 150,
                        ),
                      ],
                    ),
                  ),
                  // Text and Dog Image Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Manage ${userData["pet name"]} personal details!",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Change your pet’s personal details whenever you want.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Dog Image Section
                        Image.asset(
                          'assets/image/dog.png', // Dog image asset
                          height: 100,
                          width: 150,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  // Joined Date
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today,
                              color: const Color.fromRGBO(113, 64, 253, 100)),
                          SizedBox(width: 10),
                          Text(
                            "Joined FurCare on $Joined",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  // Pet's Details Container
                  _buildDetailsContainer(
                    title: "Pet’s Details",
                    details: {
                      "Name": "${userData["pet name"]}",
                      "Type": "${userData["pet type"]}",
                      "Breed":"${ userData["species"]}",
                      "Sex": "${userData["sex"]}",
                      "Birthday":"${ userData["date of birth"]}",
                      "Weight":"${ userData["weight"]}",
                    },
                    onEdit: _editPetDetails,
                  ),
                  SizedBox(height: 20),
                  // Owner's Details Container
                  _buildDetailsContainer(
                    title: "Owner’s Details",
                    details: {
                      "Name": "${userData["owner name"]}",
                      "Mobile Number":"${ userData["owner phone"]}",
                      "Address": "${userData["owner address"]}",
                    },
                    onEdit: _editOwnerDetails,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsContainer({
    required String title,
    required Map<String, String> details,
    required VoidCallback onEdit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(1),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Row with Edit Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: onEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color.fromRGBO(113, 64, 253, 100).withOpacity(1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: Text(
                    "Edit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            // Details List
            ...details.entries.map((entry) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 153, 153, 153),
                        ),
                      ),
                      Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (entry != details.entries.last)
                    Divider(), // Add line between items
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}