import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'MainPage.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref("Pets");

  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController petTypeController = TextEditingController();
  final TextEditingController speciesController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController ownerPhoneController = TextEditingController();
  final TextEditingController ownerAddressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  bool isCheckboxChecked = false;
  bool isButtonEnabled = false;

  void _checkFormValidity() {
    setState(() {
      isButtonEnabled = _formKey.currentState!.validate() && isCheckboxChecked;
    });
  }

  @override
  void initState() {
    super.initState();
    // Add listeners to check form validity
    petNameController.addListener(_checkFormValidity);
    petTypeController.addListener(_checkFormValidity);
    speciesController.addListener(_checkFormValidity);
    sexController.addListener(_checkFormValidity);
    dobController.addListener(_checkFormValidity);
    ownerNameController.addListener(_checkFormValidity);
    ownerPhoneController.addListener(_checkFormValidity);
    ownerAddressController.addListener(_checkFormValidity);
    emailController.addListener(_checkFormValidity);
    passwordController.addListener(_checkFormValidity);
    rePasswordController.addListener(_checkFormValidity);
    weightController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    // Dispose controllers
    petNameController.dispose();
    petTypeController.dispose();
    speciesController.dispose();
    sexController.dispose();
    dobController.dispose();
    ownerNameController.dispose();
    ownerPhoneController.dispose();
    ownerAddressController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  "Create New Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Your trusted clinic in keeping your furry friends happy and healthy",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),

                // Pet's Details Section
                Text(
                  "Pet’s Details",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                _buildTextField("Pet’s Name", petNameController),
                _buildTextField("Pet’s Type", petTypeController),
                _buildTextField("Species", speciesController),
                _buildTextField("Sex", sexController),
                _buildTextField("Date of Birth", dobController),
                _buildTextField("Weight" ,weightController ),
                SizedBox(height: 20),

                // Owner's Details Section
                Text(
                  "Owner’s Details",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                _buildTextField("Owner’s Name", ownerNameController),
                _buildTextField("Owner’s Phone No.", ownerPhoneController),
                _buildTextField("Owner’s Address", ownerAddressController),

                SizedBox(height: 20),

                // Login Credentials Section
                Text(
                  "Login Credentials",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                _buildTextField("Email", emailController),
                _buildTextField("Password", passwordController,
                    isPassword: true),
                _buildTextField("Re-enter Password", rePasswordController,
                    isPassword: true),

                SizedBox(height: 20),

                // Terms and Conditions Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: isCheckboxChecked,
                      onChanged: (value) {
                        setState(() {
                          isCheckboxChecked = value!;
                          _checkFormValidity();
                        });
                      },
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: "I agree to the ",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                          children: [
                            TextSpan(
                              text: "Terms of Service ",
                              style: TextStyle(
                                  color:
                                  const Color.fromRGBO(113, 64, 253, 100),
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: "and ",
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                              text: "Privacy Policy",
                              style: TextStyle(
                                  color:
                                  const Color.fromRGBO(113, 64, 253, 100),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Get Started Button
                ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () async {
                    await signup(
                        emailController,
                        passwordController,
                        petNameController,
                        petTypeController,
                        speciesController,
                        sexController,
                        dobController,
                        weightController,
                        ownerNameController,
                        ownerPhoneController,
                        ownerAddressController);
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isButtonEnabled
                        ? const Color.fromRGBO(113, 64, 253, 100)
                        : Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                        isButtonEnabled ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Already have an account? Login
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Navigate back to login
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Have an account? ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                              color: const Color.fromRGBO(113, 64, 253, 100),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        obscureText: isPassword,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This field is required";
          }
          return null;
        },
      ),
    );
  }

  Future<void> signup(
      emailController,
      passwordController,
      petNameController,
      petTypeController,
      speciesController,
      sexController,
      dobController,
      weightController,
      ownerNameController,
      ownerPhoneController,
      ownerAddressController) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Get the user ID
      String uid = userCredential.user!.uid;

      // Store additional user data in the Realtime Database
      await _database.child('pet$uid').set({
        'pet name': petNameController.text,
        'pet type': petTypeController.text,
        'species': speciesController.text,
        'sex': sexController.text,
        'date of birth': dobController.text,
        'weight':weightController,
        'owner name': ownerNameController.text,
        'owner phone': ownerPhoneController.text,
        'owner address': ownerAddressController.text,
        'uid': uid,
      });

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MainPage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}