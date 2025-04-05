import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pixel_adventure/auth/login_screen.dart';
import 'package:pixel_adventure/home_screen.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  // Get the default FirebaseApp instance
  FirebaseApp app = Firebase.app();

  // Initialize Firebase Realtime Database with the correct URL
  final databaseReference = FirebaseDatabase.instanceFor(
    app: app,
    databaseURL: "https://pixel-adventure-d45aa-default-rtdb.europe-west1.firebasedatabase.app",
  ).reference();

  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(MyApp(databaseReference: databaseReference));
}

class MyApp extends StatelessWidget {
  final DatabaseReference databaseReference;

  const MyApp({super.key, required this.databaseReference});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(databaseReference: databaseReference),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final DatabaseReference databaseReference;

  const AuthWrapper({super.key, required this.databaseReference});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return HomeScreen(databaseReference: databaseReference);
        }
        return const LoginScreen();
      },
    );
  }
}
