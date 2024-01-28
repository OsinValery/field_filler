import 'package:fill_field/src/game_field.dart';
import 'package:fill_field/src/game_pattern.dart';

abstract class GameBlocState {}

abstract class GameBlocEvent {}

// ---------------------------------------------
// events
// ---------------------------------------------

class InitialEvent extends GameBlocEvent {}

class TestEvent extends GameBlocEvent {}

class SelectPatternPosEvent extends GameBlocEvent {
  SelectPatternPosEvent(this.pattern, this.pos);
  List<int> pos;
  GamePattern pattern;
}

class RestartGameEvent extends GameBlocEvent {}

class BackEvent extends GameBlocEvent {}

// ---------------------------------------------
// states
// ---------------------------------------------

class InitialState extends GameBlocState {}

class ConfirmedBackState extends GameBlocState {}

class GameState extends GameBlocState {
  List<GamePattern> patterns;
  int points;
  GameField field;

  GameState(this.points, this.field, this.patterns);
}

class GameStatisticsState extends GameBlocState {
  GameStatisticsState(this.points, this.bestPoints);

  final int points;
  final int bestPoints;
}
