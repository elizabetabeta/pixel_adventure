import 'dart:developer';

import 'package:pixel_adventure/auth/auth_service.dart';
import 'package:pixel_adventure/auth/login_screen.dart';
import 'package:pixel_adventure/home_screen.dart';
import 'package:pixel_adventure/widgets/button.dart';
import 'package:pixel_adventure/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = AuthService();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  late final DatabaseReference _databaseReference;

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((_) {
      _databaseReference = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: "https://pixel-adventure-d45aa-default-rtdb.europe-west1.firebasedatabase.app",
      ).reference();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              // LOGO
              Center(
                child: Image.asset(
                  'assets/images/logo.png', 
                  height: 120,
                ),
              ),

              const SizedBox(height: 20),

              // NASLOV
              const Center(
                child: Text(
                  "Signup",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                ),
              ),

              const SizedBox(height: 50),

              // USERNAME
              CustomTextField(
                hint: "Enter Username",
                label: "Username",
                controller: _email,
              ),

              const SizedBox(height: 20),

              // PASSWORD
              CustomTextField(
                hint: "Enter Password",
                label: "Password",
                isPassword: true,
                controller: _password,
              ),

              const SizedBox(height: 30),

              // SIGNUP BUTTON
              Center(
                child: CustomButton(
                  label: "Signup",
                  onPressed: _signup,
                ),
              ),

              const SizedBox(height: 10),

              // LOGIN ako vec ima acc
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  InkWell(
                    onTap: () => goToLogin(context),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

  goToHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(databaseReference: _databaseReference),
        ),
      );

  _signup() async {
    final user = await _auth.createUserWithEmailAndPassword(_email.text, _password.text);

    if (user != null) {
      log("User Created Successfully");

      // spremanje korisnika u Realtime Database s emailom i početnim scoreom zbog leaderboarda
      await _databaseReference.child("users/${user.uid}").set({
        'email': _email.text,
        'points': 0,
      });

      goToHome(context);
    }
  }
}
