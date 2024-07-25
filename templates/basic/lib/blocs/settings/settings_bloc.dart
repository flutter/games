// Copyright 2024, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:basic/cubits/cubits.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';

part 'settings_event.dart';
part 'settings_state.dart';

/// A bloc that holds settings like [playerName] or [musicOn],
/// and saves them in a local store, i.e. hydrated.
class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  final AudioCubit _audioCubit;
  final ValueNotifier<AppLifecycleState> _appLifecycleNotifier;

  /// Creates a new instance of [SettingsState] backed by [hydration].
  ///
  /// By default, settings are persisted using [HydratedBloc]
  /// (i.e. see hive [https://pub.dev/packages/hive] for more).
  SettingsBloc({
    required AudioCubit audioCubit,
    required ValueNotifier<AppLifecycleState> appLifecycleNotifier,
  })  : _appLifecycleNotifier = appLifecycleNotifier,
        _audioCubit = audioCubit,
        super(const SettingsState()) {
    on<InitializeAudio>(_onInitializeAudio);
    on<SetPlayerName>(_onSetPlayerName);
    on<ToggleAudio>(_onToggleAudio);
    on<ToggleMusic>(_onToggleMusic);
    on<ToggleSound>(_onToggleSound);

    _appLifecycleNotifier.addListener(handleAppLifecycle);

    if (state.audioOn && state.musicOn) {
      // On the web, sound can only start after user interaction, so
      // we start muted there on every game start.
      if (kIsWeb) {
        Logger('SettingsBloc').info(
          'On the web, music can only start after user interaction.',
        );
        add(
          InitializeAudio(),
        );
      } else {
        _audioCubit.playCurrentSongInPlaylist();
      }
    }
  }

  /// Makes sure the audio cubit is listening to changes
  /// of both the app lifecycle (e.g. suspended app) and to changes
  /// of settings (e.g. muted sound).
  void handleAppLifecycle() {
    switch (_appLifecycleNotifier.value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _audioCubit.stopAllSound();
      case AppLifecycleState.resumed:
        if (state.audioOn && state.musicOn) {
          _audioCubit.startOrResumeMusic();
        }
      case AppLifecycleState.inactive:
        break;
    }
  }

  void _onInitializeAudio(
    InitializeAudio event,
    Emitter<SettingsState> emit,
  ) {
    emit(
      state.copyWith(
        audioOn: false,
      ),
    );
  }

  void _onSetPlayerName(
    SetPlayerName event,
    Emitter<SettingsState> emit,
  ) {
    emit(
      state.copyWith(
        playerName: event.name,
      ),
    );
  }

  void _onToggleAudio(
    ToggleAudio event,
    Emitter<SettingsState> emit,
  ) {
    Logger('SettingsBloc').fine('audioOn changed to ${state.audioOn}');
    if (state.audioOn) {
      // All sound just got muted. Audio is off.
      _audioCubit.stopAllSound();
    } else {
      if (state.musicOn) {
        // All sound just got un-muted. Audio is on.
        _audioCubit.startOrResumeMusic();
      }
    }

    emit(
      state.copyWith(
        audioOn: !state.audioOn,
      ),
    );
  }

  void _onToggleMusic(
    ToggleMusic event,
    Emitter<SettingsState> emit,
  ) {
    if (!state.musicOn) {
      // Music got turned on.
      if (state.audioOn) {
        _audioCubit.startOrResumeMusic();
      }
    } else {
      // Music got turned off.
      _audioCubit.state.musicPlayer.pause();
    }

    emit(
      state.copyWith(
        musicOn: !state.musicOn,
      ),
    );
  }

  void _onToggleSound(
    ToggleSound event,
    Emitter<SettingsState> emit,
  ) {
    for (final player in _audioCubit.state.sfxPlayers) {
      if (player.state == PlayerState.playing) {
        player.stop();
      }
    }

    emit(
      state.copyWith(
        soundsOn: !state.soundsOn,
      ),
    );
  }

  @override
  Future<void> close() {
    _appLifecycleNotifier.removeListener(handleAppLifecycle);
    _audioCubit.dispose();
    return super.close();
  }

  /// Asynchronously loads values from the local storage.
  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    Logger('SettingsController').fine(() => 'Loaded settings: $json');
    return SettingsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return state.toJson();
  }
}
