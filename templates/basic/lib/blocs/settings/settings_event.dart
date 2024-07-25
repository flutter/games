// Copyright 2024, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class InitializeAudio extends SettingsEvent {}

class SetPlayerName extends SettingsEvent {
  final String name;

  const SetPlayerName({
    required this.name,
  });

  @override
  List<Object> get props => [
        name,
      ];
}

class ToggleAudio extends SettingsEvent {}

class ToggleMusic extends SettingsEvent {}

class ToggleSound extends SettingsEvent {}
