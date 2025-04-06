import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum State { idle, jump }

class Cat extends SpriteAnimationGroupComponent
  with HasGameRef<PixelAdventure>, CollisionCallbacks{

  Cat({
    super.position, 
    super.size,
  });

  static const stepTime = 0.05;
  final textureSize = Vector2(32, 32);

  bool gotTouched = false;

  late final Player player;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _jumpAnimation;

  @override
  FutureOr<void> onLoad() {
    //debugMode = true;
    player = game.player;

    add(
      RectangleHitbox(
        position: Vector2(4, 6),
        size: Vector2(24, 26),
      )
    );
    _loadAllAnimation();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if(!gotTouched) {
      _updateState();
    }
    super.update(dt);   
  }
  
  void _loadAllAnimation() {
    _idleAnimation = _spriteAnimation('Idle', 7);
    _jumpAnimation = _spriteAnimation('Jump', 13);

    animations = {
      State.idle: _idleAnimation,
      State.jump: _jumpAnimation,
    };

    current = State.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(game.images.fromCache('Cats/ThreeColor/$state.png'),
    SpriteAnimationData.sequenced(
      amount: amount, 
      stepTime: stepTime, 
      textureSize: textureSize) );
  }
  
  void _updateState() {
    current = State.idle;
  }

  void collidedWithPlayer() {
  if (!gotTouched) {
    gotTouched = true;
    current = State.jump;

    gameRef.overlays.add('cat_popup');
  }
}
}