import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DoctorDetailPage extends StatefulWidget {
  final Map<String, dynamic> doctor;

  DoctorDetailPage({required this.doctor});

  @override
  _DoctorDetailPageState createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref("pets");
  String? petId;

  @override
  void initState() {
    super.initState();
    _initializePetId();
    _loadReservedTimes();
  }

  void _initializePetId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        petId = user.uid;
      });
    } else {
      print("User not logged in");
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Map<String, bool> availableTimes = {
    "Saturday: 2:00 pm - 4:00 pm": false,
    "Monday: 6:00 pm - 10:00 pm": false,
    "Thursday: 11:00 am - 2:00 pm": false,
  };

  Map<String, Map<String, dynamic>> petDetectionTypes = {
    "Vaccination & Health History Tracking": {"price": "60 egp", "checked": false},
    "Weight and Size Monitoring": {"price": "30 egp", "checked": false},
    "Breed Detection": {"price": "40 egp", "checked": false},
    "Disease and Symptom Detection": {"price": "80 egp", "checked": false},
    "Pregnancy Detection": {"price": "90 egp", "checked": false},
  };

  void _loadReservedTimes() async {
    if (petId != null) {
      String doctorId = widget.doctor['id'].toString();
      DatabaseReference appointmentsRef = databaseRef.child("$petId/appointment/$doctorId");

      try {
        DataSnapshot snapshot = await appointmentsRef.get();
        if (snapshot.exists) {
          Map<dynamic, dynamic> appointments = snapshot.value as Map<dynamic, dynamic>;

          setState(() {
            appointments.forEach((key, value) {
              String reservedTime = value['availabilityTime'];
              if (availableTimes.containsKey(reservedTime)) {
                availableTimes[reservedTime] = true;
              }
            });
          });
        }
      } catch (error) {
        print("Failed to load reserved times: $error");
      }
    }
  }

  Future<void> saveSelections() async {
    try {
      String? selectedTime = availableTimes.entries
          .firstWhere((entry) => entry.value == true, orElse: () => MapEntry("", false))
          .key;

      Map<String, dynamic> selectedDetectionTypes = Map.fromEntries(
        petDetectionTypes.entries.where((entry) => entry.value["checked"] == true),
      );

      if (selectedTime.isEmpty && selectedDetectionTypes.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Selection Missing"),
            content: Text("Please select at least one time slot or pet detection type."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
        return;
      }

      String doctorId = widget.doctor['id'].toString();
      DatabaseReference appointmentsRef = databaseRef.child("$petId/appointment/$doctorId");
      DataSnapshot snapshot = await appointmentsRef.get();

      if (snapshot.exists && selectedTime.isNotEmpty) {
        String existingTime = snapshot.value != null && snapshot.value is Map
            ? (snapshot.value as Map)['availabilityTime'] ?? ''
            : '';
        if (existingTime == selectedTime) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Time Slot Already Reserved"),
              content: Text("Please select a different time slot."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
          );
          return;
        }
      }

      await appointmentsRef.update({
        if (selectedTime.isNotEmpty) "availabilityTime": selectedTime,
        if (selectedDetectionTypes.isNotEmpty) "petDetectionTypes": selectedDetectionTypes,
      });

      setState(() {
        if (selectedTime.isNotEmpty) {
          availableTimes.remove(selectedTime);
        }
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Save Successful"),
          content: Text("Your selections have been saved."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Failed to save. Please try again."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void updateAvailableTimes(String key) {
    if (!availableTimes[key]!) {
      setState(() {
        availableTimes.updateAll((k, v) => false);
        availableTimes[key] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Doctor Info",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(widget.doctor['image']),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.doctor['name'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < widget.doctor['rating']
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.black,
                            size: 18,
                          );
                        }),
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.phone, size: 16, color: Colors.blue),
                              SizedBox(width: 8),
                              Text(
                                "070-4012965",
                                style: TextStyle(fontSize: 14, color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text("Available Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            buildAvailableTimes(),
            Text("Pet Detection Types", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            buildPetDetectionTypes(),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: saveSelections,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAvailableTimes() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5)],
      ),
      child: Column(
        children: availableTimes.entries.map((entry) {
          final parts = entry.key.split(": ");
          final day = parts[0];
          final time = parts[1];
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: "$day: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                        TextSpan(text: time, style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  Radio<bool>(
                    value: true,
                    groupValue: entry.value,
                    onChanged: (value) {
                      if (!entry.value) {
                        updateAvailableTimes(entry.key);
                      }
                    },
                    activeColor: Colors.purple,
                  ),
                ],
              ),
              if (entry.key != availableTimes.keys.last) Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget buildPetDetectionTypes() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5)],
      ),
      child: Column(
        children: petDetectionTypes.entries.map((entry) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(entry.key)),
                  Text(entry.value["price"], style: TextStyle(color: Colors.grey[700])),
                  Checkbox(
                    value: entry.value["checked"],
                    onChanged: (bool? value) {
                      setState(() {
                        petDetectionTypes[entry.key]!["checked"] = value!;
                      });
                    },
                    activeColor: Colors.purple,
                  ),
                ],
              ),
              if (entry.key != petDetectionTypes.keys.last) Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }
}