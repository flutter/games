// Copyright 2024, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:basic/audio/songs.dart';
import 'package:basic/audio/sounds.dart';
import 'package:basic/blocs/blocs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

part 'audio_state.dart';

/// Allows playing music and sound. A facade to `package:audioplayers`.
class AudioCubit extends Cubit<AudioState> {
  AudioCubit() : super(AudioState.initial());

  static final log = Logger('AudioCubit');

  Future<void> playCurrentSongInPlaylist() async {
    log.info('Playing ${state.playlist.first} now.');
    try {
      await state.musicPlayer.play(
        AssetSource('music/${state.playlist.first.filename}'),
      );
    } catch (err) {
      log.severe(
        'Could not play song ${state.playlist.first}',
        err,
      );
    }
  }

  /// Preloads all sound effects.
  Future<void> preloadSfx() async {
    log.info('Preloading sound effects');
    // This assumes there is only a limited number of sound effects in the game.
    // If there are hundreds of long sound effect files, it's better
    // to be more selective when preloading.
    await AudioCache.instance.loadAll(
      SfxType.values
          .expand(soundTypeToFilename)
          .map((path) => 'sfx/$path')
          .toList(),
    );
  }

  void handleSongFinished(void _) {
    log.info('Last song finished playing.');
    // Move the song that just finished playing to the end of the playlist.
    state.playlist.addLast(state.playlist.removeFirst());
    // Play the song at the beginning of the playlist.
    playCurrentSongInPlaylist();
  }

  void initializeAudio() {
    log.info('Initialize music repeat.');
    state.musicPlayer.onPlayerComplete.listen(handleSongFinished);
    unawaited(preloadSfx());
  }

  /// Plays a single sound effect, defined by [type].
  ///
  /// The controller will ignore this call when the attached settings'
  /// [SettingsState.audioOn] is `true` or if its
  /// [SettingsState.soundsOn] is `false`.
  void playSfx(
    SfxType type,
    SettingsState settings,
  ) {
    final audioOn = settings.audioOn;
    if (!audioOn) {
      log.fine(() => 'Ignoring player sound ($type) because audio is muted.');
      return;
    }
    final soundsOn = settings.soundsOn;
    if (!soundsOn) {
      log.fine(() =>
          'Ignoring playing sound ($type) because sounds are turned off.');
      return;
    }

    log.fine(() => 'Playing sound: $type');
    final options = soundTypeToFilename(type);
    final filename = options[Random().nextInt(options.length)];
    log.fine(() => 'Chosen filename: $filename');

    final currentPlayer = state.sfxPlayers[state.currentSfxPlayer];

    currentPlayer.play(
      AssetSource('sfx/$filename'),
      volume: soundTypeToVolume(type),
    );

    emit(
      state.copyWith(
          currentSfxPlayer:
              (state.currentSfxPlayer + 1) % state.sfxPlayers.length),
    );
  }

  void startOrResumeMusic() async {
    if (state.musicPlayer.source == null) {
      log.info('No music source set. '
          'Start playing the current song in playlist.');
      await playCurrentSongInPlaylist();
      return;
    }

    log.info('Resuming paused music.');
    try {
      state.musicPlayer.resume();
    } catch (err) {
      // Sometimes, resuming fails with an "Unexpected" error.
      log.severe('Error resuming music', err);
      // Try starting the song from scratch.
      playCurrentSongInPlaylist();
    }
  }

  void stopAllSound() {
    log.info('Stopping all sound.');
    state.musicPlayer.pause();
    for (final player in state.sfxPlayers) {
      player.stop();
    }
  }

  void dispose() {
    log.info('Dispose.');
    stopAllSound();
    state.musicPlayer.dispose();
    for (final player in state.sfxPlayers) {
      player.dispose();
    }
  }
}
