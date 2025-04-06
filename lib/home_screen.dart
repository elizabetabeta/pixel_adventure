import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/auth/auth_service.dart';
import 'package:pixel_adventure/auth/login_screen.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/widgets/button.dart';
import 'package:pixel_adventure/widgets/LessonOverlay.dart';
import 'package:flame/game.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pixel_adventure/leaderboard_screen.dart';

class HomeScreen extends StatefulWidget {
  final DatabaseReference databaseReference;

  const HomeScreen({super.key, required this.databaseReference});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = AuthService();
  User? user;
  int userScore = 0;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _listenToUserScore();
  }

  void _listenToUserScore() {
    if (user != null) {
      final userScoreRef = widget.databaseReference.child('users/${user!.uid}/points');
      userScoreRef.onValue.listen((event) {
        final score = event.snapshot.value;
        if (score != null) {
          setState(() {
            userScore = int.tryParse(score.toString()) ?? 0;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = user?.email ?? "Unknown";

    return Scaffold(
      body: Stack(
        children: [
          // korisnik info
          Positioned(
            top: 30,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, size: 18, color: Colors.black87),
                      const SizedBox(width: 6),
                      Text(
                        userEmail,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 18, color: Colors.amber),
                      const SizedBox(width: 6),
                      Text(
                        "Score: $userScore",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Buttons
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(label: "Level 1",textColor: Colors.deepPurple, onPressed: () => startGame(context, 1)),
                const SizedBox(height: 10),
                CustomButton(label: "Level 2",textColor: Colors.deepPurple,onPressed: () => startGame(context, 2)),
                const SizedBox(height: 10),
                CustomButton(label: "Level 3",textColor: Colors.deepPurple, onPressed: () => startGame(context, 3)),
                const SizedBox(height: 10),
                CustomButton(
                  label: "Leaderboard",
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeaderboardScreen(
                          databaseReference: widget.databaseReference,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Sign out button
          Positioned(
            top: 40,
            right: 20,
            child: CustomButton(
              label: "Sign Out",
              textColor: Colors.red,
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

  void goToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
