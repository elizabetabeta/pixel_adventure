import 'package:firebase_auth/firebase_auth.dart';
import 'package:pixel_adventure/auth/auth_service.dart';
import 'package:pixel_adventure/auth/login_screen.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/widgets/button.dart';
import 'package:pixel_adventure/widgets/LessonOverlay.dart';
import 'package:pixel_adventure/widgets/cat_popup.dart'; // Import the CatPopup
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final User? user = FirebaseAuth.instance.currentUser;
    final String userEmail = user?.email ?? "Unknown";

    return Scaffold(
      body: Stack(
        children: [
          // Display user email at the top left
          Positioned(
            top: 40,
            left: 20,
            child: Text(
              "Logged in as: $userEmail",
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),

          // Buttons to start levels
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(label: "Level 1", onPressed: () => startGame(context, 1)),
                const SizedBox(height: 10),
                CustomButton(label: "Level 2", onPressed: () => startGame(context, 2)),
                const SizedBox(height: 10),
                CustomButton(label: "Level 3", onPressed: () => startGame(context, 3)),
              ],
            ),
          ),

          // Sign Out Button
          Positioned(
            top: 40,
            right: 20,
            child: CustomButton(
              label: "Sign Out",
              onPressed: () async {
                await auth.signout();
                goToLogin(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void startGame(BuildContext context, int level) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LessonOverlay(
        level: level,
        onStart: () {
          final game = PixelAdventure(level: level); // Create the game instance

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GameWidget(
                game: game,
                overlayBuilderMap: {
                  'cat_popup': (context, _) => CatPopup(game: game), // Pass the game instance
                },
              ),
            ),
          );
        },
      ),
    ),
  );
}

  void goToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
