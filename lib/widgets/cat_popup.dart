import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class CatPopup extends StatelessWidget {
  final PixelAdventure game;

  const CatPopup({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        title: const Text("Pronašli ste pitanje!"),
        content: const Text("Koji znak treba staviti na prazno mjesto: 2 _ 5?"),
        actions: [
          TextButton(
            onPressed: () {
              game.overlays.remove('cat_popup'); // Removes the pop-up
            },
            child: const Text("<"),
          ),
          TextButton(
            onPressed: () {
              game.overlays.remove('cat_popup'); // Also removes the pop-up
            },
            child: const Text(">"),
          ),
        ],
      ),
    );
  }
}
