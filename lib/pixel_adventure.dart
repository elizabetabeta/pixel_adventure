import 'dart:async';


import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';

class PixelAdventure extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks {

    @override
    Color backgroundColor() => const Color(0xFF211F30);
    Player player = Player(character: 'Ninja Frog');
    late JoystickComponent joystick;
    bool showrJoystick = false;

    @override
    FutureOr<void> onLoad() async{

        await images.loadAllImages();

        world = Level(
            player: player,
            levelName: 'Level-01'
            );

        camera = CameraComponent.withFixedResolution(
            world: world, width: 640, height: 360
            );
        camera.viewfinder.anchor = Anchor.topLeft;

        addAll([camera, world]);
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
}


