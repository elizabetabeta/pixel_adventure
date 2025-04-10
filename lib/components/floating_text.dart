import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class FloatingText extends TextComponent with HasGameRef<PixelAdventure> {
  final double riseAmount = 20.0;
  final double duration = 0.8;
  final Paint paint;

  FloatingText({
    required Vector2 position,
    required String text,
    Color color = Colors.white,
  })  : paint = Paint()..color = color,
        super(
          position: position,
          text: text,
          anchor: Anchor.center,
          priority: 10,
          textRenderer: TextPaint(
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final Vector2 target = position - Vector2(0, riseAmount);
    add(MoveEffect.to(
      target,
      EffectController(duration: duration, curve: Curves.easeOut),
      onComplete: () => removeFromParent(),
    ));
  }
}
