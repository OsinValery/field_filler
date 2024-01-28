import 'package:fill_field/pages/modes_list/bloc_helper.dart';
import 'package:fill_field/src/game_mode.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModesListBloc extends Bloc<BlocEvent, BlocState> {
  ModesListBloc() : super(InitialState()) {
    on<InitialEvent>(_onInitState);
    on<SelectModeEvent>(_onSelectMode);

    Future.delayed(const Duration(milliseconds: 2))
        .then((_) => add(InitialEvent()));
    standartGamemodes.sort((a, b) =>
        switch ((a.size[0] == a.size[1]) != (b.size[0] == b.size[1])) {
          true => a.size[0] == a.size[1] ? -1 : 1,
          false => switch (a.size[0].compareTo(b.size[0])) {
              0 => a.size[1].compareTo(b.size[1]),
              -1 => -1,
              _ => 1
            }
        });
  }

  _onInitState(event, Emitter emitter) {
    emitter(ModesListState(standartGamemodes));
  }

  _onSelectMode(event, Emitter emitter) {
    emitter(SelectGameState(event.mode));
  }
}

List<GameMode> standartGamemodes = [
  for (int summ = 7; summ <= 20; summ++)
    for (int i = 5; i < summ - 4; i++) GameMode([i, summ - i]),
  GameMode([11, 11]),
  GameMode([12, 12]),
  GameMode([13, 13]),
  GameMode([14, 14]),
  GameMode([15, 15]),
  GameMode([16, 16]),
];
