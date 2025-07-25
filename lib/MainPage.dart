import 'package:flutter/material.dart';
import 'package:untitled/Emergency.dart';
import 'package:untitled/medical.dart';

import 'doctor_detail_page.dart';
import 'emergency.dart';
import 'settings_page.dart';
class MainPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MainPage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> doctors = [
    {"name": "Dr.Momon", "rating": 3, "image": "assets/image/dr.momon.png" , "id" : "9820"},
    {"name": "Dr.Ola", "rating": 4, "image": "assets/image/dr.ola.png", "id" : "6436"},
    {"name": "Dr.Raul", "rating": 5, "image": "assets/image/dr.raul.png", "id" : "0293"},
  ];
  List<Map<String, dynamic>> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    filteredDoctors = doctors; // Initialize with all doctors
  }

  void searchDoctor(String query) {
    final suggestions = doctors.where((doctor) {
      final doctorName = doctor['name'].toLowerCase();
      final input = query.toLowerCase();
      return doctorName.contains(input);
    }).toList();

    setState(() {
      filteredDoctors = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/background.png"), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Top Bar with Settings Icon
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsPage(), // Navigate to SettingsPage
                              ),
                            );
                          },
                          child: Icon(Icons.settings , color: Colors.white,size: 30,)
                      ),
                      SizedBox(width: 90),
                      Text(
                        "Home",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 40),
                      InkWell(
                          onTap: () {
                            //EmergencyPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedicalRecordPage(), // Navigate to SettingsPage
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.notification_important_sharp , color: Colors.red, size: 30,),
                              Text("Emergency" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500 ,color: Colors.red),)
                            ],
                          ))
                    ],
                  ),
                  SizedBox(height: 20),
                  // Search Bar
                  TextField(
                    controller: searchController,
                    onChanged: searchDoctor,
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Doctor Image
                  CircleAvatar(
                    radius: 150,
                    backgroundImage: AssetImage("assets/image/doctor_image.png"),
                  ),
                  SizedBox(height: 50),
                  // List of Doctors
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredDoctors.length,
                      itemBuilder: (context, index) {
                        final doctor = filteredDoctors[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          shadowColor: Colors.grey[200],
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 5,
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(doctor['image']),
                            ),
                            title: Text(
                              doctor['name'],
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Row(
                              children: List.generate(5, (i) {
                                return Icon(
                                  i < doctor['rating']
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                );
                              }),
                            ),
                            trailing:
                            Icon(Icons.arrow_forward_ios), // Add arrow
                            onTap: () {
                              // Navigate to DoctorDetailPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DoctorDetailPage(
                                    doctor: doctor, // Pass doctor data
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}