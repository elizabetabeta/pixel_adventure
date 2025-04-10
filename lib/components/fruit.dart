import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/custom_hitbox.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pixel_adventure/components/floating_text.dart';


class Fruit extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final String fruit;

  Fruit({
    this.fruit = 'Apple',
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  final double stepTime = 0.05;
  final hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 10,
    width: 12,
    height: 12,
  );

  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    priority = -1;

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/$fruit.png'),
      SpriteAnimationData.sequenced(
        amount: 17,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
    return super.onLoad();
  }

  void collidedWithPlayer() async {
  if (!collected) {
    collected = true;

    game.updateScore(1);

    game.add(
      FloatingText(
        position: position + Vector2(100, 30),
        text: '+1',
        color: const Color.fromARGB(255, 89, 255, 0),
      ),
    );

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final database = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: "https://pixel-adventure-d45aa-default-rtdb.europe-west1.firebasedatabase.app",
      );

      final userRef = database.ref().child('users/${user.uid}/points');

      final snapshot = await userRef.once();
      int currentPoints = 0;
      if (snapshot.snapshot.value != null) {
        final value = snapshot.snapshot.value;
        if (value is int) {
          currentPoints = value;
        } else if (value is String) {
          currentPoints = int.tryParse(value) ?? 0;
        }
      }
      int newScore = currentPoints + 1;


      await userRef.set(newScore);

      //print("User ${user.email} new score: $newScore");
      //print("Updating points for user: ${user.email} (${user.uid})");

    }

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/Collected.png'),
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );

    await animationTicker?.completed;
    removeFromParent();
  }
}
}