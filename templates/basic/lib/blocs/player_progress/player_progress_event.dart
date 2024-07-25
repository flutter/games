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
