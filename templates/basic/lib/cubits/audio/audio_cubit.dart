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

  Future<void> preloadSfx() async {
    log.info('Preloading sound effects');
    await AudioCache.instance.loadAll(
      SfxType.values
          .expand(soundTypeToFilename)
          .map((path) => 'sfx/$path')
          .toList(),
    );
  }

  void handleSongFinished(void _) {
    log.info('Last song finished playing.');
    state.playlist.addLast(state.playlist.removeFirst());
    playCurrentSongInPlaylist();
  }

  void initializeAudio() {
    log.info('Initialize music repeat.');
    state.musicPlayer.onPlayerComplete.listen(handleSongFinished);
    unawaited(preloadSfx());
  }

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
      log.severe('Error resuming music', err);
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
