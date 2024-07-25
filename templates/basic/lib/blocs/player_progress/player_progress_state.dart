part of 'player_progress_bloc.dart';

class PlayerProgressState extends Equatable {
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
