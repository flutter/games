part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final bool audioOn;
  final bool musicOn;
  final bool soundsOn;
  final String playerName;

  const SettingsState({
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
