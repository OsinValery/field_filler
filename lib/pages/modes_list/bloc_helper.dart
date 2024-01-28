import 'package:fill_field/src/game_mode.dart';

abstract class BlocState {}

abstract class BlocEvent {}

// ---------------------------------------------
// events
// ---------------------------------------------

final class InitialEvent extends BlocEvent {}

final class SelectModeEvent extends BlocEvent {
  GameMode mode;
  SelectModeEvent(this.mode);
}

// ---------------------------------------------
// states
// ---------------------------------------------

final class InitialState extends BlocState {}

final class ModesListState extends BlocState {
  late List<GameMode> modes;
  ModesListState(this.modes);
}

final class SelectGameState extends BlocState {
  GameMode mode;
  SelectGameState(this.mode);
}
