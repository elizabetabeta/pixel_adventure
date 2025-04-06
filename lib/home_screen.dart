import 'package:firebase_auth/firebase_auth.dart';
import 'package:pixel_adventure/auth/auth_service.dart';
import 'package:pixel_adventure/auth/login_screen.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/widgets/button.dart';
import 'package:pixel_adventure/widgets/LessonOverlay.dart';
import 'package:pixel_adventure/widgets/cat_popup.dart'; // Import the CatPopup
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

          // Sign Out Button
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
