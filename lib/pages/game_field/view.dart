import 'package:fill_field/pages/common/background.dart';
import 'package:fill_field/pages/common/page_back_button.dart';
import 'package:fill_field/src/game_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fill_field/src/game_pattern.dart';
import 'package:go_router/go_router.dart';

import 'bloc.dart';
import 'bloc_helper.dart';
import 'widgets.dart';

class GameWidget extends StatefulWidget {
  const GameWidget({super.key, this.gameMode});

  final dynamic gameMode;

  @override
  State<GameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  @override
  Widget build(BuildContext context) {
    var gameMode = widget.gameMode ?? GameMode([9, 9], loadOld: false);

    GameBloc bloc = GameBloc(gameMode);
    return Scaffold(
      body: BlocProvider.value(value: bloc, child: const GameContent()),
    );
  }
}

class GameContent extends StatelessWidget {
  const GameContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      child: BlocConsumer<GameBloc, GameBlocState>(
        buildWhen: (previous, current) =>
            current is GameState || current is GameStatisticsState,
        builder: (context, state) {
          if (state is InitialState) return Container();
          if (state is GameStatisticsState) {
            return PresentResulstPage(state: state);
          }
          return GameScene(state: state);
        },
        listenWhen: (previous, current) => current is ConfirmedBackState,
        listener: (context, state) {
          if (state is ConfirmedBackState) context.pop();
        },
      ),
    );
  }
}

class GameScene extends StatelessWidget {
  const GameScene({super.key, required this.state});

  final GameBlocState state;

  @override
  Widget build(BuildContext context) {
    int margin = 40;
    var size = MediaQuery.of(context).size;
    var width = size.width - 2 * margin;
    var height = size.height / 2;
    var side = 0.0;

    side = width / (state as GameState).field.width;
    if (side * (state as GameState).field.height > height) {
      side = height / (state as GameState).field.height;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PageBackButton(
                  onPress: () => context.read<GameBloc>().add(BackEvent()))
            ],
          ),
          const Expanded(flex: 2, child: Center(child: PointsCounter())),
          GameArea(
            key: UniqueKey(),
            fieldSide: side,
            field: (state as GameState).field,
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              color: Colors.yellowAccent.withAlpha(150),
            ),
            constraints: BoxConstraints(minHeight: side * 1.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                (state as GameState).patterns.length,
                (index) => Draggable<GamePattern>(
                  maxSimultaneousDrags: 1,
                  data: (state as GameState).patterns[index],
                  feedback: PatternView(
                      pattern: (state as GameState).patterns[index],
                      fieldSize: side),
                  dragAnchorStrategy: (draggable, context, position) => Offset(
                    side * (state as GameState).patterns[index].width / 2,
                    side * (state as GameState).patterns[index].height,
                  ),
                  childWhenDragging: Container(
                    color: Colors.blue.withAlpha(200),
                    child: PatternView(
                        pattern: (state as GameState).patterns[index],
                        fieldSize: side / 3),
                  ),
                  child: Container(
                    color: Colors.grey.withAlpha(1),
                    padding: const EdgeInsets.all(8.0),
                    child: PatternView(
                        pattern: (state as GameState).patterns[index],
                        fieldSize: side / 2),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class PresentResulstPage extends StatelessWidget {
  const PresentResulstPage({super.key, required this.state});

  final GameStatisticsState state;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 4),
          Image.asset(
            "assets/best_score.png",
            fit: BoxFit.fitWidth,
            scale: 0.9,
          ),
          const Spacer(flex: 3),
          Transform.scale(
            scale: 1.6,
            child: ResultsScoreView(score: state.bestPoints),
          ),
          const Spacer(flex: 12),
          ScaleAnimation(
            animate: state.points >= state.bestPoints,
            key: UniqueKey(),
            child: Transform.scale(
                scale: 1.2,
                child: ResultsScoreView(score: state.points, c: TColor.green)),
          ),
          const Spacer(flex: 4),
          Flexible(
            flex: 5,
            child: GestureDetector(
              onTap: () => context.read<GameBloc>().add(RestartGameEvent()),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                height: size.height / 10,
                width: size.width * 0.4,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 102, 0),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: const Text(
                  'Restart',
                  style: TextStyle(
                    color: Color.fromARGB(255, 14, 14, 236),
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(flex: 7),
        ],
      ),
    );
  }
}
