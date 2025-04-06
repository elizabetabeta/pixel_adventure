import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class CatPopup extends StatefulWidget {
  final PixelAdventure game;

  const CatPopup({super.key, required this.game});

  @override
  State<CatPopup> createState() => _CatPopupState();
}

class _CatPopupState extends State<CatPopup> {
  String question = "Učitavanje...";
  String correctAnswer = "";
  String wrongAnswer = "";
  bool answered = false;
  String resultMessage = "";

  @override
  void initState() {
    super.initState();
    fetchQuestion();
  }

  void fetchQuestion() async {
    final database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: "https://pixel-adventure-d45aa-default-rtdb.europe-west1.firebasedatabase.app",
    );
    final ref = database.ref().child("questions/level${widget.game.level}");

    final snapshot = await ref.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      setState(() {
        question = data['question'];
        correctAnswer = data['correctAnswer'];
        wrongAnswer = data['wrongAnswer'];
      });
    } else {
      setState(() {
        question = "Nema pitanja za ovaj level.";
      });
    }
  }

 void handleAnswer(String selectedAnswer) async {
  bool isCorrect = selectedAnswer == correctAnswer;

  // Add 10 points to game score if the answer is correct
  if (isCorrect) {
    widget.game.score += 10;  // Use widget.game to access the score
  }

  // Update Firebase Database
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: "https://pixel-adventure-d45aa-default-rtdb.europe-west1.firebasedatabase.app",
    );

    // Reference to the current user's points
    final userRef = database.ref().child('users/${user.uid}/points');

    // Get the current points from Firebase
    final snapshot = await userRef.once();
    int currentPoints = snapshot.snapshot.value != null
        ? (snapshot.snapshot.value as int)
        : 0;

    // Calculate new score
    int newScore = currentPoints + (isCorrect ? 10 : 0);

    // Update the points in Firebase
    await userRef.set(newScore);
  }

  // Update UI
  setState(() {
    resultMessage = isCorrect ? "Točno!" : "Netočno!";
    answered = true;
  });
}


  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        title: const Text("Pronašli ste pitanje!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(question),
            if (!answered) ...[
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => handleAnswer(correctAnswer),
                child: Text(correctAnswer),
              ),
              TextButton(
                onPressed: () => handleAnswer(wrongAnswer),
                child: Text(wrongAnswer),
              ),
            ],
            if (answered) ...[
              const SizedBox(height: 10),
              Text(resultMessage, style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: resultMessage == "Točno!" ? Colors.green : Colors.red,
              )),
            ]
          ],
        ),
        actions: answered
            ? [
                TextButton(
                  onPressed: () {
                    widget.game.overlays.remove(PixelAdventure.catPopupOverlay);
                  },
                  child: const Text("OK"),
                )
              ]
            : [],
      ),
    );
  }
}
