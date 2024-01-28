import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../src/field.dart';
import '../../src/game_field.dart';
import '../../src/game_pattern.dart';

import 'bloc_helper.dart';
import 'bloc.dart';

class GameArea extends StatelessWidget {
  const GameArea({
    super.key,
    required this.fieldSide,
    required this.field,
  });

  final double fieldSide;
  final GameField field;

  @override
  Widget build(BuildContext context) {
    const margin = 10.0;
    return DragTarget<GamePattern>(
      onAcceptWithDetails: (details) {
        var t =
            context.findRenderObject()?.getTransformTo(null).getTranslation();
        var leftCorner = Offset(details.offset.dx - t!.x - margin,
            context.size!.height - details.offset.dy + t.y - margin);

        var x = leftCorner.dx / fieldSide;
        var y = leftCorner.dy / fieldSide;
        context.read<GameBloc>().add(SelectPatternPosEvent(
              details.data,
              [x.round(), y.round() - details.data.height],
            ));
      },
      builder: (_, __, ___) => Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 240, 129, 95).withAlpha(150),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(
              width: 3, color: const Color.fromARGB(255, 255, 115, 64)),
        ),
        padding: const EdgeInsets.all(margin),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            field.width,
            (dx) => Column(
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.up,
              children: List.generate(
                  field.height,
                  (dy) =>
                      OneFieldSquare(size: fieldSide, field: field[dx][dy])),
            ),
          ),
        ),
      ),
    );
  }
}

class PatternView extends StatelessWidget {
  const PatternView({
    super.key,
    required this.pattern,
    required this.fieldSize,
  });

  final double fieldSize;
  final GamePattern pattern;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withAlpha(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          pattern.width,
          (dx) => Column(
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.up,
            children: List.generate(
              pattern.height,
              (dy) => OneFieldSquare(size: fieldSize, field: pattern[dx][dy]),
            ),
          ),
        ),
      ),
    );
  }
}

class PointsCounter extends StatelessWidget {
  const PointsCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameBlocState>(
      buildWhen: (previous, current) {
        if (previous is! GameState || current is! GameState) return false;
        return previous.points != current.points;
      },
      builder: (context, state) {
        int points = state is GameState ? state.points : 0;
        return PointsCounterTextAnimation(
          text: points.toString(),
        );
      },
    );
  }
}

/// this widget animates change of argument [text]
class PointsCounterTextAnimation extends StatefulWidget {
  const PointsCounterTextAnimation({super.key, required this.text});

  final String text;

  @override
  State<PointsCounterTextAnimation> createState() =>
      _PointsCounterAnimationState();
}

class _PointsCounterAnimationState extends State<PointsCounterTextAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 275),
      reverseDuration: const Duration(milliseconds: 150),
      animationBehavior: AnimationBehavior.preserve,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PointsCounterTextAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      if (!_controller.isAnimating) {
        _controller.forward().then((value) => _controller.reverse());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var animation = TextStyleTween(
      begin: const TextStyle(color: Colors.greenAccent, fontSize: 60),
      end: const TextStyle(color: Colors.blue, fontSize: 90),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
      reverseCurve: Curves.linear,
    ));

    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Text(
            widget.text,
            style: animation.value.copyWith(
              fontWeight: FontWeight.bold,
            ),
          );
        });
  }
}

class OneFieldSquare extends StatelessWidget {
  const OneFieldSquare({super.key, required this.size, required this.field});

  final OneField field;
  final double size;

  @override
  Widget build(BuildContext context) {
    const margin = 2.0;
    return Container(
      decoration: BoxDecoration(
          color: field.free ? Colors.grey.withAlpha(40) : field.color,
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      width: size - 2 * margin,
      height: size - 2 * margin,
      margin: const EdgeInsets.all(margin),
    );
  }
}

class ResultsScoreView extends StatelessWidget {
  const ResultsScoreView({super.key, required this.score, this.c = TColor.red});

  final TColor c;
  final int score;

  Iterable<int> get scoreDigits {
    int tmp = score;
    List<int> result = [];
    do {
      result.add(tmp % 10);
      tmp ~/= 10;
    } while (tmp > 10);
    result.add(tmp);
    return result.reversed;
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children:
            scoreDigits.map((d) => Image.asset("assets/$c$d.png")).toList(),
      ),
    );
  }
}

class ScaleAnimation extends StatefulWidget {
  const ScaleAnimation({super.key, required this.animate, required this.child});

  final Widget child;
  final bool animate;

  @override
  State<ScaleAnimation> createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
      duration: const Duration(milliseconds: 600),
    );
    var tween = Tween<double>(begin: 1.0, end: 1.6);
    animation = tween.animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    ));
    controlAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void controlAnimation() {
    var dt = const Duration(milliseconds: 2);
    var dt2 = const Duration(milliseconds: 20);
    _controller.forward().then(
          (_) => Future.delayed(dt).then(
            (_) => _controller.reverse().then(
                  (_) => Future.delayed(dt2).then(
                    (_) => controlAnimation(),
                  ),
                ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) return widget.child;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

enum TColor {
  green,
  lightGreen,
  red;

  @override
  String toString() {
    return {TColor.green: "gr", TColor.red: "r", TColor.lightGreen: "g"}[this]!;
  }
}
