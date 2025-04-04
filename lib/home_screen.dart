import 'package:pixel_adventure/auth/auth_service.dart';
import 'package:pixel_adventure/auth/login_screen.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/widgets/button.dart';
import 'package:pixel_adventure/widgets/LessonOverlay.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    return Scaffold(
      body: Stack(
        children: [
          // Dugmad za pokretanje levela
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
          
          // Dugme za odjavu
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
     Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => GameWidget(game: PixelAdventure(level: level)),
  ),
);
          },
        ),
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
}
