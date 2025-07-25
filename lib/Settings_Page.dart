import 'privacy.dart';
import 'package:flutter/material.dart';
import 'PetDetailsPage.dart';
import 'medical.dart';
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/image/SP.png', // Replace with your background asset
              fit: BoxFit.cover,
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button and Title Row
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Navigate back
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white, // Button background color
                            borderRadius:
                                BorderRadius.circular(15), // Rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: Offset(0, 2), // Shadow position
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back, // Back arrow icon
                            color: Colors.black, // Icon color
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                          width: 12), // Spacing between the button and text
                      Text(
                        "Settings Page",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Settings List
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // "Account" Section
                        SizedBox(height: 130),
                        _buildSettingsSection(
                          sectionTitle: "Account",
                          buttons: [
                            {
                              "title": "Account",
                              "iconPath": 'assets/image/Profile.png',
                              "onTap": () {
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PetDetailsPage(),
                                  ),
                                );
                              },
                            },
                            {
                              "title": "Privacy",
                              "iconPath": 'assets/image/privacy.png',
                              "onTap": () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PrivacyPage(),
                                  ),
                                );
                              },
                            },
                            {
                              "title": "Medical Record",
                              "iconPath": 'assets/image/medical.png',
                              "onTap": () {
                                 Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MedicalRecordPage(),
                                  ),
                                );
                              },
                            },
                          ],
                        ),
                        // Divider between Medical Record and Help
                        Divider(
                          color: const Color.fromRGBO(113, 64, 253, 100)
                              .withOpacity(1),
                          thickness: 1.5,
                          height: 20,
                        ),
                        // "Help" Section
                        _buildSettingsSection(
                          sectionTitle: "Help",
                          buttons: [
                            {
                              "title": "Contact Us",
                              "iconPath": 'assets/image/Call.png',
                              "onTap": () {
                                // Handle Contact Us Navigation
                              },
                            },
                            {
                              "title": "FAQ",
                              "iconPath": 'assets/image/faq.png',
                              "onTap": () {
                                // Handle FAQ Navigation
                              },
                            },
                          ],
                        ),
                        Spacer(),
                        // Logout Button
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              // Perform Logout
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/image/logout.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 50,
                                horizontal: 110,
                              ),
                              child: Text(
                                "Logout",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromRGBO(113, 64, 253, 100)
                                      .withOpacity(1),
                                ),
                              ),
                            ),
                          ),
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
    );
  }

  Widget _buildSettingsSection({
    required String sectionTitle,
    required List<Map<String, dynamic>> buttons,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        SizedBox(height: 10), // Spacing after the section title
        ...buttons.map((button) {
          return _buildSettingsButton(
            title: button["title"],
            iconPath: button["iconPath"],
            onTap: button["onTap"],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSettingsButton({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
            ),
            SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: const Color.fromARGB(255, 0, 0, 0), // Text color
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 22, color: const Color.fromARGB(255, 0, 0, 0)),
          ],
        ),
      ),
    );
  }
}
