import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../components/player.dart';

/// The [HurtEffect] is an effect that is composed of multiple different effects
/// that are added to the [Player] when it is hurt.
/// It spins the player, shoots it up in the air and makes it blink in white.
class HurtEffect extends Component with ParentIsA<Player> {
  @override
  void onMount() {
    super.onMount();
    const effectTime = 0.5;
    parent.addAll(
      [
        RotateEffect.by(
          pi * 2,
          EffectController(
            duration: effectTime,
            curve: Curves.easeInOut,
          ),
        ),
        MoveByEffect(
          Vector2(0, -400),
          EffectController(
            duration: effectTime,
            curve: Curves.easeInOut,
          ),
          onComplete: removeFromParent,
        ),
        ColorEffect(
          Colors.white,
          const Offset(0.0, 0.9),
          EffectController(
            duration: effectTime / 8,
            alternate: true,
            repeatCount: 2,
          ),
        ),
      ],
    );
  }
}
