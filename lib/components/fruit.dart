import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/custom_hitbox.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

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

    // Increase the game score
    game.score += 1;

    // Update Firebase Database
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final database = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: "https://pixel-adventure-d45aa-default-rtdb.europe-west1.firebasedatabase.app",
      );

      // Reference the points of the currently logged-in user
      final userRef = database.ref().child('users/${user.uid}/points');

      // Get the current points from Firebase
      final snapshot = await userRef.once();

      // Safely cast the value to int (if the value exists)
      int currentPoints = snapshot.snapshot.value != null
          ? (snapshot.snapshot.value as int)
          : 0;

      // Add the newly collected points to the current score
      int newScore = currentPoints + 1;  // Increment by 1 for each collected fruit

      // Save the new score back to Firebase for the logged-in user
      await userRef.set(newScore);

      // Optional: You can also add a print statement to confirm the update
      print("User ${user.email} new score: $newScore");
      print("Updating points for user: ${user.email} (${user.uid})");

    }

    // Play collected animation and remove fruit
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