import 'dart:math';

import 'package:fill_field/pages/common/page_back_button.dart';
import 'package:fill_field/src/game_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fill_field/pages/common/background.dart';
import 'package:go_router/go_router.dart';

import 'bloc.dart';
import 'bloc_helper.dart';

class ModesListView extends StatelessWidget {
  const ModesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ModesListBloc>.value(
        value: ModesListBloc(),
        child: const MainPageContent(),
      ),
    );
  }
}

class MainPageContent extends StatefulWidget {
  const MainPageContent({super.key});

  @override
  State<MainPageContent> createState() => _MainPageContentState();
}

class _MainPageContentState extends State<MainPageContent> {
  Container get decorBox {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var windowSize = MediaQuery.of(context).size;
    var smallestSide = min(windowSize.width, windowSize.height);
    const double elementMaxSize = 100;

    var emptyBox = DragTarget<GameMode>(
      onAccept: (data) =>
          context.read<ModesListBloc>().add(SelectModeEvent(data)),
      builder: (context, data, data2) => Container(
        decoration: BoxDecoration(
          color: data.isEmpty
              ? Colors.grey.withAlpha(120)
              : Colors.green.withAlpha(120),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        margin: const EdgeInsets.all(4),
      ),
    );

    var boxes = [
      emptyBox,
      emptyBox,
      emptyBox,
      emptyBox,
      emptyBox,
      emptyBox,
      emptyBox,
      emptyBox,
      decorBox,
      decorBox,
      emptyBox,
      decorBox,
      decorBox,
      decorBox,
      emptyBox
    ];

    var tip = const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text("drag game mode into field", style: TextStyle(fontSize: 24)),
    );

    boxes.shuffle();
    return Scaffold(
      body: BlocConsumer<ModesListBloc, BlocState>(
        listenWhen: (previous, current) => current is SelectGameState,
        buildWhen: (previous, current) => current is! SelectGameState,
        listener: (context, state) {
          if (state is SelectGameState) {
            context.pushReplacement('/game', extra: state.mode);
          }
        },
        builder: ((context, state) {
          if (state is InitialState) return Container();
          return WillPopScope(
            onWillPop: () async => false,
            child: Background(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [PageBackButton(onPress: context.pop)],
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                        bottom: 0,
                      ),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.yellow.withAlpha(150),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: SelectGameTarget(children: boxes),
                    ),
                  ),
                  tip,
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SingleChildScrollView(
                        child: Wrap(
                          children: (state as ModesListState).modes.map((e) {
                            var boxSize = min(smallestSide / 4, elementMaxSize);
                            return Draggable(
                              data: e,
                              maxSimultaneousDrags: 1,
                              dragAnchorStrategy: (_, __, ___) =>
                                  Offset(boxSize / 4, boxSize / 2),
                              feedback: Material(
                                child: Container(
                                  width: boxSize / 2,
                                  height: boxSize / 2,
                                  color: Colors.purple,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${e.size[0]}x${e.size[1]}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              child: Container(
                                width: boxSize - 8,
                                height: boxSize - 8,
                                alignment: Alignment.center,
                                color: Colors.green,
                                margin: const EdgeInsets.all(4),
                                child: Text(
                                  "${e.size[0]}x${e.size[1]}",
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class SelectGameTarget extends StatelessWidget {
  const SelectGameTarget(
      {super.key, required this.children, this.widgetsInRow = 5});

  final List<Widget> children;
  final int widgetsInRow;

  @override
  Widget build(BuildContext context) {
    List<Widget> curRow = [];
    List<Widget> columnContent = [];
    for (var wid in children) {
      curRow.add(
        Flexible(
          child: AspectRatio(aspectRatio: 1, child: wid),
        ),
      );
      if (curRow.length == widgetsInRow) {
        columnContent.add(Flexible(
            child: Row(
          mainAxisSize: MainAxisSize.min,
          children: curRow,
        )));
        curRow = [];
      }
    }
    if (curRow.isNotEmpty) {
      columnContent.add(Flexible(
          child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: curRow,
      )));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnContent,
    );
  }
}
