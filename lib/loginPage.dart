import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'MainPage.dart';
import 'createaccount.dart';
import 'forgetpassword.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isButtonEnabled = false;

  void _checkInputFields() {
    setState(() {
      isButtonEnabled =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(_checkInputFields);
    passwordController.addListener(_checkInputFields);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Text
              SizedBox(height: 40),
              Text(
                "Hello,",
                style: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 37,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 25),
              Text(
                "Your trusted clinic in keeping your furry friends happy and healthy",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 40),
              // Email Input Field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              // Password Input Field
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              // Forget Password and Create Account
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Forget Password?",
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color.fromRGBO(113, 64, 253, 100),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateAccountPage(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don’t have an account? ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey, // Grey for the first part
                              ),
                            ),
                            TextSpan(
                              text: "Create Account",
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color.fromRGBO(113, 64, 253,
                                    100), // Purple for "Create Account"
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              // Get Started Button
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () {
                    signin(emailController, passwordController);
                  }
                      : null, // Disable button if fields are empty
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signin(emailAddress, password) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailAddress.text,
      password: password.text,
    )
        .then((credential) {
      // Navigate to the HomeScreen if sign-in is successful
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(), // Navigate to Dashboard
        ),
      );
    }).catchError((error) {
      // Check if the error is of type FirebaseAuthException
      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (error.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        } else {
          // Handle other Firebase authentication errors
          print('An error occurred: ${error.message}');
        }
      } else {
        // Handle any other errors
        print('An unexpected error occurred: $error');
      }
    });
  }
}