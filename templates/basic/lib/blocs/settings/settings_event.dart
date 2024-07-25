part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

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
