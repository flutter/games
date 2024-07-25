// Copyright 2024, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'player_progress_event.dart';
part 'player_progress_state.dart';

/// A bloc that holds the player's progress.
class PlayerProgressBloc
    extends HydratedBloc<PlayerProgressEvent, PlayerProgressState> {
  /// Creates a new instance of [SettingsState] backed by [hydration].
  ///
  /// By default, settings are persisted using [HydratedBloc]
  /// (i.e. see hive [https://pub.dev/packages/hive] for more).
  PlayerProgressBloc() : super(const PlayerProgressState()) {
    on<Reset>(_onReset);
    on<SetHighestLevelReached>(_onSetHighestLevelReached);
  }

  /// Resets the player's progress so it's like if they just started
  /// playing the game for the first time.
  void _onReset(
    Reset event,
    Emitter<PlayerProgressState> emit,
  ) {
    emit(
      state.copyWith(
        highestLevelReached: 0,
      ),
    );
  }

  /// Registers [level] as reached.
  ///
  /// If this is higher than [highestLevelReached], it will update that
  /// value and save it to the injected persistence store.
  void _onSetHighestLevelReached(
    SetHighestLevelReached event,
    Emitter<PlayerProgressState> emit,
  ) {
    if (event.level > state.highestLevelReached) {
      emit(
        state.copyWith(
          highestLevelReached: event.level,
        ),
      );
    }
  }

  /// Fetches the latest data from the backing persistence store.
  @override
  PlayerProgressState? fromJson(Map<String, dynamic> json) {
    return PlayerProgressState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(PlayerProgressState state) {
    return state.toJson();
  }
}
