// Copyright 2024, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'player_progress_bloc.dart';

abstract class PlayerProgressEvent extends Equatable {
  const PlayerProgressEvent();

  @override
  List<Object> get props => [];
}

class Reset extends PlayerProgressEvent {}

class SetHighestLevelReached extends PlayerProgressEvent {
  final int level;

  const SetHighestLevelReached({
    required this.level,
  });

  @override
  List<Object> get props => [
        level,
      ];
}
