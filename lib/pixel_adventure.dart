import 'dart:async';


import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';

class PixelAdventure extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {

    @override
    Color backgroundColor() => const Color(0xFF211F30);
    Player player = Player(character: 'Ninja Frog');
    late JoystickComponent joystick;
    bool showrJoystick = false;
    List<String> levelNames = ['Level-01', 'Level-01'];
    int currentLevelIndex = 0;

    @override
    FutureOr<void> onLoad() async{

        await images.loadAllImages();

        _loadLevel();


        if (showrJoystick) {
            addJoystick();
        }

        return super.onLoad();
    }

    @override
    void update(double dt) {
    if (showrJoystick) {
        updateJoystick();
    }
    super.update(dt);
  }

    void addJoystick() {
        joystick = JoystickComponent(
            knob: SpriteComponent(
                sprite: Sprite(
                    images.fromCache('HUD/Knob.png'),
                ),
            ),
            //knobRadius: 32,
            background: SpriteComponent(
                sprite: Sprite(
                    images.fromCache('HUD/Joystick.png'),
                ),
            ),
            margin: const EdgeInsets.only(right: -240, bottom: -100),
            priority: 100,
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
        if(currentLevelIndex < levelNames.length - 1) {
          currentLevelIndex++;
          _loadLevel();
        } else {
          // no more levels
        }
      }
      

      void _loadLevel() {
        Future.delayed(const Duration(seconds: 1), () {
          Level world = Level(
            player: player,
            levelName: levelNames[currentLevelIndex],
        );

        camera = CameraComponent.withFixedResolution(
          world: world, width: 640, height: 360
          );
        camera.viewfinder.anchor = Anchor.topLeft;

        addAll([camera, world]);    
        });
        
      }
}


