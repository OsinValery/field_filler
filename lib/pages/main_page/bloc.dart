import 'dart:async';

import 'package:fill_field/src/game_delegate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_helper.dart';

class MainPageBloc extends Bloc<Event, PageState> {
  MainPageBloc() : super(InitialState()) {
    on<InitialEvent>(_onInitPage);
    on<CheckLastGameEvent>(_onCheckLastGame);

    Future.delayed(const Duration(milliseconds: 3))
        .then((value) => add(InitialEvent()));

    Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (isClosed) {
        timer.cancel();
      } else {
        add(CheckLastGameEvent());
      }
    });
  }

  _onInitPage(event, Emitter emitter) async {
    bool haveLastGame = await GameDelegate().haveSavedGame();
    emitter(HaveLastGame(haveLastGame));
  }

  _onCheckLastGame(event, Emitter emitter) async {
    bool haveLastGame = await GameDelegate().haveSavedGame();
    emitter(HaveLastGame(haveLastGame));
  }
}
