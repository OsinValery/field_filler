abstract class Event {}

abstract class PageState {}

// ---------------------------------------------
// events
// ---------------------------------------------

final class InitialEvent extends Event {}

final class CheckLastGameEvent extends Event {}

// ---------------------------------------------
// states
// ---------------------------------------------

final class InitialState extends PageState {}

final class HaveLastGame extends PageState {
  bool haveGame;
  HaveLastGame(this.haveGame);
}
