// Copyright 2024, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'audio_cubit.dart';

enum AudioStatus {
  error,
  intial,
  loaded,
  loading,
}

class AudioState extends Equatable {
  final AudioStatus audioStatus;
  final AudioPlayer musicPlayer;
  final int currentSfxPlayer;

  /// This is a list of [AudioPlayer] instances which are rotated to play
  /// sound effects.
  final List<AudioPlayer> sfxPlayers;

  final Queue<Song> playlist;

  const AudioState({
    required this.audioStatus,
    this.currentSfxPlayer = 0,
    required this.musicPlayer,
    required this.playlist,
    required this.sfxPlayers,
  });

  @override
  List<Object> get props => [
        audioStatus,
        currentSfxPlayer,
        musicPlayer,
        playlist,
        sfxPlayers,
      ];

  /// Creates an instance that plays music and sound.
  ///
  /// Use [polyphony] to configure the number of sound effects (SFX) that can
  /// play at the same time. A [polyphony] of `1` will always only play one
  /// sound (a new sound will stop the previous one). See discussion
  /// of [_sfxPlayers] to learn why this is the case.
  ///
  /// Background music does not count into the [polyphony] limit. Music will
  /// never be overridden by sound effects because that would be silly.
  factory AudioState.initial() {
    int polyphony = 2;
    return AudioState(
      audioStatus: AudioStatus.intial,
      musicPlayer: AudioPlayer(
        playerId: 'musicPlayer',
      ),
      playlist: Queue.of(List<Song>.of(songs)..shuffle),
      sfxPlayers: Iterable.generate(
        polyphony,
        (i) => AudioPlayer(
          playerId: 'sfxPlayers$i',
        ),
      ).toList(),
    );
  }

  AudioState copyWith({
    AudioStatus? audioStatus,
    AudioPlayer? musicPlayer,
    int? currentSfxPlayer,
    List<AudioPlayer>? sfxPlayers,
    Queue<Song>? playlist,
  }) {
    return AudioState(
      audioStatus: audioStatus ?? this.audioStatus,
      currentSfxPlayer: currentSfxPlayer ?? this.currentSfxPlayer,
      musicPlayer: musicPlayer ?? this.musicPlayer,
      playlist: playlist ?? this.playlist,
      sfxPlayers: sfxPlayers ?? this.sfxPlayers,
    );
  }
}
