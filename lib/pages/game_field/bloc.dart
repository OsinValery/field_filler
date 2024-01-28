import 'package:fill_field/pages/game_field/bloc_helper.dart';
import 'package:fill_field/src/best_score_loader.dart';
import 'package:fill_field/src/game_delegate.dart';
import 'package:fill_field/src/game_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameBloc extends Bloc<GameBlocEvent, GameBlocState> {
  GameBloc(this.gameMode) : super(InitialState()) {
    Future.delayed(const Duration(milliseconds: 2))
        .then((value) => add(InitialEvent()));

    on<InitialEvent>(_onInitGameState);
    on<RestartGameEvent>(_onInitGameState);
    on<TestEvent>(_onTestEvent);
    on<SelectPatternPosEvent>(_onMove);
    on<BackEvent>(_onBackEvent);
  }

  bool canMove = true;
  int bestScore = 0;
  GameMode gameMode;

  _onInitGameState(event, Emitter emitter) async {
    var gameDelegate = GameDelegate();
    await gameDelegate.initGameState(gameMode);
    if (gameMode.loadOld) {
      gameMode = GameMode(gameDelegate.gameField.size, loadOld: false);
    }

    bestScore = await BestScoreLoader().getScore(gameMode);

    emitter(GameState(
      gameDelegate.points,
      gameDelegate.gameField,
      gameDelegate.patterns,
    ));
  }

  _onBackEvent(event, Emitter emitter) {
    print("want back, confirm it!");
    emitter(ConfirmedBackState());
  }

  _onTestEvent(event, Emitter emitter) async {
    print("test");
  }

  _onMove(SelectPatternPosEvent event, Emitter emitter) async {
    var dx = event.pos.first, dy = event.pos.last;
    var pattern = event.pattern;

    var gameDelegate = GameDelegate();
    canMove = false;
    var canAdd = gameDelegate.gameField.canAdd(dx, dy, pattern);

    if (canAdd) {
      var newField = gameDelegate.applyGamePattern(dx, dy, pattern);
      emitter(GameState(gameDelegate.points, newField, gameDelegate.patterns));
      await Future.delayed(const Duration(milliseconds: 100));

      var removeFilter = gameDelegate.checkCanRemove(Colors.black);
      emitter(GameState(gameDelegate.points, newField, gameDelegate.patterns));
      await Future.delayed(const Duration(milliseconds: 300));

      var status = gameDelegate.finishMovement(removeFilter, pattern);
      emitter(GameState(gameDelegate.points, newField, gameDelegate.patterns));
      if (gameDelegate.points > bestScore) {
        bestScore = gameDelegate.points;
        BestScoreLoader().saveScore(bestScore, gameMode);
      }

      switch (status) {
        case 0:
          break;
        case 1:
          print("field is clear");
          break;
        case 2:
          print("game finished");
          await Future.delayed(const Duration(seconds: 2));
          emitter(GameStatisticsState(gameDelegate.points, bestScore));
          gameDelegate.deleteLastGame();
          break;
      }
    }
    canMove = true;
  }
}
