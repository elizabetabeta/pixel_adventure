import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/components/jump_button.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';

class PixelAdventure extends FlameGame with 
    HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection, TapCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  int level;
  int initialScore;

  PixelAdventure({required this.level, this.initialScore = 0}) {
    score = initialScore; 
  } 
  static const String catPopupOverlay = 'cat_popup';
  static const String lessonOverlay = 'lesson_overlay';

  int score = 0;
  late TextComponent scoreText; 
  Player player = Player(character: 'Ninja Frog');
  late JoystickComponent joystick;
  bool showControls = true;
  bool playSounds = true;
  double soundVolume = 1.0;
  List<String> levelNames = ['Level-01', 'Level-02', 'Level-03'];
  
  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    loadLevel();

    
    scoreText = TextComponent(
      text: 'Score: $score',
      position: Vector2(10, 10), 
      priority: 2,
      textRenderer: TextPaint(style: TextStyle(color: Colors.white, fontSize: 20)),
    );
    add(scoreText);  

    if (showControls) {
      addJoystick();
      add(JumpButton());
    }
    return super.onLoad();
  }

  void updateScore(int points) {
    score += points;
    scoreText.text = 'Score: $score'; 
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
        priority: 10,
        knob: SpriteComponent(
            sprite: Sprite(
                images.fromCache('HUD/Knob.png'),
            ),
        ),
        background: SpriteComponent(
            sprite: Sprite(
                images.fromCache('HUD/Joystick.png'),
            ),
        ),
        margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.downRight:
      case JoystickDirection.upRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }

   void loadNextLevel() {
    removeWhere((component) => component is Level);
    
    if (level < levelNames.length) {
      level++;
    } else {
      level = 1;
    }
    loadLevel();
  }
  
  void loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      Level world = Level(
        player: player,
        levelName: levelNames[level - 1],
      );

      camera = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360
      )..priority=1;
      camera.viewfinder.anchor = Anchor.topLeft;

      addAll([camera, world]);    
    });
  }
}
