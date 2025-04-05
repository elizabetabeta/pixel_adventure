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
          // Email + score
          Positioned(
            top: 40,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Logged in as: $userEmail",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  "Score: $userScore",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),

          // Level buttons + leaderboard
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CustomButton(label: "Level 1", onPressed: () => startGame(context, 1)),
      const SizedBox(height: 10),
      CustomButton(label: "Level 2", onPressed: () => startGame(context, 2)),
      const SizedBox(height: 10),
      CustomButton(label: "Level 3", onPressed: () => startGame(context, 3)),
      const SizedBox(height: 10),
      CustomButton(
        label: "Leaderboard",
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


          // Sign out
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

  void goToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
