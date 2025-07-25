import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MedicalRecordPage extends StatefulWidget {
  @override
  _MedicalRecordPageState createState() => _MedicalRecordPageState();
}

class _MedicalRecordPageState extends State<MedicalRecordPage> {
  final DatabaseReference database =
  FirebaseDatabase.instance.ref("pets");
  final TextEditingController nameVaccinationController =
  TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? petId;

  @override
  void initState() {
    super.initState();
    _initializePetId();
  }
  void _initializePetId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        petId = user.uid;
      });
    } else {
      print("User not logged in");
      // Redirect to login page or show a warning
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button and Logo Row
                  Padding(
                    padding: const EdgeInsets.all(16.0),
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
                        SizedBox(width: 8),
                        Image.asset(
                          'assets/image/logo.png', // Logo asset
                          height: 80,
                          width: 150,
                        ),
                      ],
                    ),
                  ),
                  // Text and Image Row
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
                                "Health is the most important!",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Stay in touch with your Pet's health records.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Medical Image Section
                        Image.asset(
                          'assets/image/medical_record.png', // Image asset
                          height: 150,
                          width: 150,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  // Veterinary Info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Doctor Info
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Veterinary Surgeon",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "Dr. Rivin Jayasuriya",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // Contact Number
                        Row(
                          children: [
                            Icon(Icons.phone,
                                color:  Color(0x9C7140FD)),
                            SizedBox(width: 6),
                            Text(
                              "070-4012965",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  // Stats Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard(
                          icon: Icons.calendar_today,
                          title: "Last visited day",
                          value: "01/01/2024",
                        ),
                        _buildStatCard(
                          icon: Icons.calendar_today,
                          title: "Next Visit",
                          value: "01/03/2024",
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard(
                          icon: Icons.monitor_weight,
                          title: "Last weight check",
                          value: "20 kg",
                        ),
                        _buildStatCard(
                          icon: Icons.medical_services,
                          title: "Total operations done",
                          value: "1",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  // Vaccination Records
                  _buildHeader(),
                  SizedBox(height: 15),
                  _buildDetailSection(
                    title: "Vaccination Records",
                    path: "pets/$petId/vaccination_records",
                    addFunction: (title, date) => addRecord(
                      "pets/$petId/vaccination_records",
                      title,
                      date,
                    ),
                  ),
                  SizedBox(height: 15),
                  _buildDetailSection(
                    title: "Food Allergies",
                    path: "pets/$petId/food_allergies",
                    addFunction: (title, _) => addRecord(
                      "pets/$petId/food_allergies",
                      title,
                      null,
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color.fromRGBO(113, 64, 253, 100)),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Pet Medical Records",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Icon(Icons.pets, size: 30, color: Color(0x9C7140FD)),
        ],
      ),
    );
  }

  Widget _buildDetailSection({
    required String title,
    required String path,
    required Function(String title, String? date) addFunction,
  }) {
    return StreamBuilder(
      stream: FirebaseDatabase.instance.ref(path).onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        List<Map<String, String>> details = [];
        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          details = data.entries.map((entry) {
            return {
              "title": entry.value["title"]?.toString() ?? "",
              "date": entry.value["date"]?.toString() ?? "",
            };
          }).toList();

        }

        return _buildDetailCard(
          title: title,
          details: details,
          onAddPressed: () {
            nameVaccinationController.clear();
            dateController.clear();
            showDialog(
              context: context,
              builder: (context) => _buildAddDialog(
                context: context,
                title: title,
                addFunction: addFunction,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailCard({
    required String title,
    required List<Map<String, String>> details,
    required VoidCallback onAddPressed,
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
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Color(0x9C7140FD)),
                  onPressed: onAddPressed,
                ),
              ],
            ),
            ...details.map((detail) => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(detail["title"]!, style: TextStyle(fontSize: 16)),
                    if (detail["date"]!.isNotEmpty)
                      Text(
                        detail["date"]!,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                  ],
                ),
                if (detail != details.last) Divider(),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildAddDialog({
    required BuildContext context,
    required String title,
    required Function(String title, String? date) addFunction,
  }) {
    bool isDateRequired = title == "Vaccination Records";

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Add $title",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: nameVaccinationController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            if (isDateRequired)
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: "Date"),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameVaccinationController.text.isNotEmpty &&
                    (!isDateRequired || dateController.text.isNotEmpty)) {
                  addFunction(nameVaccinationController.text, dateController.text);
                  Navigator.pop(context);
                } else {
                  print("Fields cannot be empty");
                }
              },
              child: Text("Add"),
            ),
          ],
        ),
      ),
    );
  }

  void addRecord(String path, String title, String? date) {
    final database = FirebaseDatabase.instance.ref(path).push();
    database
        .set({
      "title": title,
      if (date != null) "date": date,
    })
        .then((_) => print("Record added successfully!"))
        .catchError((error) => print("Failed to add record: $error"));
  }
}