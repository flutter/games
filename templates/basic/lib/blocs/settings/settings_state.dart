// Copyright 2024, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final bool audioOn;
  final bool musicOn;
  final bool soundsOn;
  final String playerName;

  const SettingsState({
    /// Whether or not the audio is on at all. This overrides both music
    /// and sounds (sfx).
    ///
    /// This is an important feature especially on mobile, where players
    /// expect to be able to quickly mute all the audio. Having this as
    /// a separate flag (as opposed to some kind of {off, sound, everything}
    /// enum) means that the player will not lose their [soundsOn] and
    /// [musicOn] preferences when they temporarily mute the game.
    this.audioOn = true,
    this.musicOn = true,
    this.playerName = 'Player',
    this.soundsOn = true,
  });

  @override
  List<Object> get props => [
        audioOn,
        musicOn,
        playerName,
        soundsOn,
      ];

  SettingsState copyWith({
    bool? audioOn,
    bool? musicOn,
    bool? soundsOn,
    String? playerName,
  }) {
    return SettingsState(
      audioOn: audioOn ?? this.audioOn,
      musicOn: musicOn ?? this.musicOn,
      playerName: playerName ?? this.playerName,
      soundsOn: soundsOn ?? this.soundsOn,
    );
  }

  factory SettingsState.fromJson(Map<String, dynamic> json) {
    return SettingsState(
      audioOn: json['audioOn'] as bool,
      musicOn: json['musicOn'] as bool,
      playerName: json['playerName'] as String,
      soundsOn: json['soundsOn'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'audioOn': audioOn,
      'musicOn': musicOn,
      'playerName': playerName,
      'soundsOn': soundsOn,
    };
  }
}
