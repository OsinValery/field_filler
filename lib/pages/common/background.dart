import 'dart:math';
import 'package:flutter/material.dart';

class Background extends StatefulWidget {
  const Background({super.key, this.child});

  final Widget? child;

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> with TickerProviderStateMixin {
  List<WaveDescription> waves = [];
  DateTime? startOfPress;

  @override
  void dispose() {
    for (var wave in waves) {
      wave.dispose();
    }
    super.dispose();
  }

  void runAnimation(Offset center) {
    const mcsc = 1000000;
    final pressDuration = DateTime.now().difference(startOfPress!);
    final rate = pow(pressDuration.inMilliseconds + 1, 1 / 1.7) / 10;
    var animDur = Duration(microseconds: (0.9 * rate * mcsc).round().toInt());

    var controller = AnimationController(vsync: this, duration: animDur);
    controller.addListener(() => setState(() {}));

    var wave = WaveDescription(controller, 50.0 * rate, center);
    waves.add(wave);
    controller.forward().then((_) {
      waves.remove(wave);
      wave.dispose();
    });
  }

  _handleStartPress() => startOfPress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => runAnimation(details.globalPosition),
      onTapDown: (details) => _handleStartPress(),
      child: Container(
          color: const Color.fromARGB(248, 255, 160, 64),
          child: CustomPaint(
            painter: WavesPainter(waves),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: widget.child,
            ),
          )),
    );
  }
}

class WavesPainter extends CustomPainter {
  WavesPainter(this.waves) : super();
  List<WaveDescription> waves;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    for (var wave in waves) {
      canvas.drawCircle(
        wave.center,
        wave.radiusAnimation!.value,
        Paint()
          ..color = wave.colorAnimation!.value
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }
}

class WaveDescription {
  final AnimationController _controller;
  Animation? radiusAnimation;
  Animation? colorAnimation;
  Offset center;

  WaveDescription(
    this._controller,
    double radius,
    this.center, {
    color = Colors.redAccent,
  }) {
    radiusAnimation = Tween(begin: 0.0, end: radius).animate(_controller);
    colorAnimation = ColorTween(
      begin: color,
      end: Colors.transparent,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuad,
      ),
    );
  }

  dispose() => _controller.dispose();
}
