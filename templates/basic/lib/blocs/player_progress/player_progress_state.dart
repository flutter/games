// Copyright 2024, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'player_progress_bloc.dart';

class PlayerProgressState extends Equatable {
  /// The highest level that the player has reached so far.
  final int highestLevelReached;

  const PlayerProgressState({
    this.highestLevelReached = 0,
  });

  @override
  List<Object> get props => [
        highestLevelReached,
      ];

  PlayerProgressState copyWith({
    int? highestLevelReached,
  }) {
    return PlayerProgressState(
      highestLevelReached: highestLevelReached ?? this.highestLevelReached,
    );
  }

  factory PlayerProgressState.fromJson(Map<String, dynamic> json) {
    return PlayerProgressState(
      highestLevelReached: json['highestLevelReached'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'highestLevelReached': highestLevelReached,
    };
  }
}
