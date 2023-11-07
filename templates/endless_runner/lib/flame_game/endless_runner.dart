import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../audio/audio_controller.dart';
import '../level_selection/levels.dart';
import '../player_progress/player_progress.dart';
import 'components/background.dart';
import 'endless_world.dart';

/// This is the base of the game which is added to the [GameWidget].
///
/// This class defines a few different properties for the game:
///  - That it should run collision detection, this is done through the
///  [HasCollisionDetection] mixin.
///  - That it should have a [FixedResolutionViewport] with a size of 1600x720,
///  this means that even if you resize the window, the game itself will keep
///  the defined virtual resolution.
///  - That the default world that the camera is looking at should be the
///  [EndlessWorld].
///
/// Note that both of the last are passed in to the super constructor, they
/// could also be set inside of `onLoad` for example.
class EndlessRunner extends FlameGame<EndlessWorld> with HasCollisionDetection {
  EndlessRunner({
    required this.level,
    required PlayerProgress playerProgress,
    required this.audioController,
  }) : super(
          world: EndlessWorld(level: level, playerProgress: playerProgress),
          camera: CameraComponent.withFixedResolution(width: 1600, height: 720),
        );

  /// What the properties of the level that is played has.
  final GameLevel level;

  /// A helper for playing sound effects and background audio.
  final AudioController audioController;

  /// In the [onLoad] method you load different type of assets and set things
  /// that only needs to be set once when the level starts up.
  @override
  Future<void> onLoad() async {
    // The backdrop is a static layer behind the world that the camera is
    // looking at, so here we add our parallax background.
    camera.backdrop.add(Background(speed: world.speed));

    // With the `TextPaint` we define what properties the text that we are going
    // to render will have, like font family, size and color in this instance.
    final textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: 30,
        color: Colors.white,
        fontFamily: 'Press Start 2P',
      ),
    );

    final scoreText = 'Embers: 0 / ${level.winScore}';

    // The component that is responsible for rendering the text that contains
    // the current score.
    final scoreComponent = TextComponent(
      text: scoreText,
      position: Vector2.all(30),
      textRenderer: textRenderer,
    );

    // The scoreComponent is added to the viewport, which means that even if the
    // camera's viewfinder move around and looks at different positions in the
    // world, the score is always static to the viewport.
    camera.viewport.add(scoreComponent);

    // Here we add a listener to the notifier that is updated when the player
    // gets a new point, in the callback we update the text of the
    // `scoreComponent`.
    world.scoreNotifier.addListener(() {
      scoreComponent.text =
          scoreText.replaceFirst('0', '${world.scoreNotifier.value}');
    });
  }
}
