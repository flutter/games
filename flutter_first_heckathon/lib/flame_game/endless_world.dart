import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../level_selection/levels.dart';
import '../player_progress/player_progress.dart';
import 'components/obstacle.dart';
import 'components/player.dart';
import 'components/point.dart';
import 'game_screen.dart';

/// The world is where you place all the components that should live inside of
/// the game, like the player, enemies, obstacles and points for example.
/// The world can be much bigger than what the camera is currently looking at,
/// but in this game all components that go outside of the size of the viewport
/// are removed, since the player can't interact with those anymore.
///
/// The [EndlessWorld] has two mixins added to it:
///  - The [TapCallbacks] that makes it possible to react to taps (or mouse
///  clicks) on the world.
///  - The [HasGameReference] that gives the world access to a variable called
///  `game`, which is a reference to the game class that the world is attached
///  to.
class EndlessWorld extends World with TapCallbacks, HasGameReference {
  EndlessWorld({
    required this.level,
    required this.playerProgress,
    Random? random,
  }) : _random = random ?? Random();

  /// The properties of the current level.
  final GameLevel level;

  /// Used to see what the current progress of the player is and to update the
  /// progress if a level is finished.
  final PlayerProgress playerProgress;

  /// The speed is used for determining how fast the background should pass by
  /// and how fast the enemies and obstacles should move.
  late double speed = _calculateSpeed(level.number);

  /// In the [scoreNotifier] we keep track of what the current score is, and if
  /// other parts of the code is interested in when the score is updated they
  /// can listen to it and act on the updated value.
  final scoreNotifier = ValueNotifier(0);
  late final Player player;
  late final DateTime timeStarted;
  Vector2 get size => (parent as FlameGame).size;
  int levelCompletedIn = 0;

  /// The random number generator that is used to spawn periodic components.
  final Random _random;

  /// The gravity is defined in virtual pixels per second squared.
  /// These pixels are in relation to how big the [FixedResolutionViewport] is.
  final double gravity = 30;

  /// Where the ground is located in the world and things should stop falling.
  late final double groundLevel = (size.y / 2) - (size.y / 5);

  @override
  Future<void> onLoad() async {
    // Used to keep track of when the level started, so that we later can
    // calculate how long time it took to finish the level.
    timeStarted = DateTime.now();

    // The player is the component that we control when we tap the screen, the
    // Dash in this case.
    player = Player(
      position: Vector2(-size.x / 3, groundLevel - 900),
      addScore: addScore,
      resetScore: resetScore,
    );
    add(player);

    add(
      SpawnComponent(
        factory: (_) => Obstacle.random(
          random: _random,
          canSpawnTall: level.canSpawnTall,
        ),
        period: 5,
        area: Rectangle.fromPoints(
          Vector2(size.x / 2, groundLevel),
          Vector2(size.x / 2, groundLevel),
        ),
        random: _random,
      ),
    );

    add(
      SpawnComponent.periodRange(
        factory: (_) => Point(),
        minPeriod: 3.0,
        maxPeriod: 5.0 + level.number,
        area: Rectangle.fromPoints(
          Vector2(size.x / 2, -size.y / 2 + Point.spriteSize.y),
          Vector2(size.x / 2, groundLevel),
        ),
        random: _random,
      ),
    );

    // When the player takes a new point we check if the score is enough to
    // pass the level and if it is we calculate what time the level was passed
    // in, update the player's progress and open up a dialog that shows that
    // the player passed the level.
    scoreNotifier.addListener(() {
      if (scoreNotifier.value >= level.winScore) {
        final levelTime = (DateTime.now().millisecondsSinceEpoch -
                timeStarted.millisecondsSinceEpoch) /
            1000;

        levelCompletedIn = levelTime.round();

        playerProgress.setLevelFinished(level.number, levelCompletedIn);
        game.pauseEngine();
        game.overlays.add(GameScreen.winDialogKey);
      }
    });
  }

  @override
  void onMount() {
    super.onMount();
    // When the world is mounted in the game we add a back button widget as an
    // overlay so that the player can go back to the previous screen.
    game.overlays.add(GameScreen.backButtonKey);
  }

  @override
  void onRemove() {
    game.overlays.remove(GameScreen.backButtonKey);
  }

  /// Gives the player points, with a default value +1 points.
  void addScore({int amount = 1}) {
    scoreNotifier.value += amount;
  }

  /// Sets the player's score to 0 again.
  void resetScore() {
    scoreNotifier.value = 0;
  }

  /// [onTapDown] is called when the player taps the screen and then calculates
  /// if and how the player should jump.
  @override
  void onTapDown(TapDownEvent event) {
    // Which direction the player should jump.
    final towards = (event.localPosition - player.position)..normalize();
    // If the tap is underneath the player no jump is triggered, but if it is
    // above the player it triggers a jump, even though the player might be in
    // the air. This makes it possible to later implement double jumping inside
    // of the `player` class if one would want to.
    if (towards.y.isNegative) {
      player.jump(towards);
    }
  }

  /// A helper function to define how fast a certain level should be.
  static double _calculateSpeed(int level) => 200 + (level * 200);
}
