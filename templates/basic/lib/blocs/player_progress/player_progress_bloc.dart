import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
// import 'package:logging/logging.dart';

part 'player_progress_event.dart';
part 'player_progress_state.dart';

class PlayerProgressBloc
    extends HydratedBloc<PlayerProgressEvent, PlayerProgressState> {
  PlayerProgressBloc() : super(const PlayerProgressState()) {
    on<Reset>(_onReset);
    on<SetHighestLevelReached>(_onSetHighestLevelReached);
  }

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

  @override
  PlayerProgressState? fromJson(Map<String, dynamic> json) {
    // Logger('PlayerProgress').fine(() => 'Loaded progress: $json');
    // TODO: kIsWeb audioOn should be false (?)
    return PlayerProgressState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(PlayerProgressState state) {
    return state.toJson();
  }
}
