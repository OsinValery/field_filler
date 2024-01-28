import 'package:fill_field/pages/common/background.dart';
import 'package:fill_field/pages/main_page/bloc.dart';
import 'package:fill_field/pages/main_page/bloc_helper.dart';
import 'package:fill_field/src/game_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MainPageView extends StatelessWidget {
  const MainPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<MainPageBloc>.value(
        value: MainPageBloc(),
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
  @override
  Widget build(BuildContext context) {
    var appName = Image.asset("assets/name.png");
    return BlocConsumer<MainPageBloc, PageState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Background(
          child: Column(
            children: [
              Expanded(flex: 3, child: Align(child: appName)),
              const Expanded(flex: 6, child: PlayButton()),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () => context.push(
                      "/game",
                      extra: GameMode([-1, -1], loadOld: true),
                    ),
                    child: AnimatedContainer(
                      width: double.infinity,
                      height: state is HaveLastGame
                          ? state.haveGame
                              ? 100
                              : 0
                          : 0,
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent.withAlpha(150),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                      ),
                      duration: const Duration(milliseconds: 500),
                      alignment: Alignment.center,
                      child: const Text(
                        "last game",
                        style: TextStyle(
                            color: Color.fromARGB(255, 101, 22, 204),
                            fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PlayButton extends StatefulWidget {
  const PlayButton({super.key});

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  List<WaveDescription> waves = [];

  GlobalKey buttonKey = GlobalKey();
  final btnColor = Colors.yellowAccent;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
      reverseDuration: const Duration(milliseconds: 700),
      animationBehavior: AnimationBehavior.preserve,
    );
    var tween = Tween<double>(begin: 1.0, end: 0.75);
    animation = tween.animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
      reverseCurve: Curves.easeOutBack,
    ));

    controlAnimation();
  }

  Future workFinish() async {
    var animDur = const Duration(seconds: 7);
    var controller = AnimationController(vsync: this, duration: animDur);
    controller.addListener(() => setState(() {}));

    var btnSize = buttonKey.currentContext?.size;

    // second box fixes bug when resize window
    var box = context.findRenderObject() as RenderBox?;
    Offset? pos = box?.localToGlobal(Offset.zero);
    box = buttonKey.currentContext?.findRenderObject() as RenderBox?;
    Offset? pos2 = box?.localToGlobal(Offset.zero);
    var center = Offset(pos2!.dx + btnSize!.width / 2, pos!.dy);

    var wave = MainPageWaveDescription(
      controller,
      btnSize.width * 1.1,
      center,
      startRadius: btnSize.width / 2 * 0.99,
      color: btnColor.withAlpha(150),
    );
    waves.add(wave);
    controller.forward().then((_) {
      waves.remove(wave);
      wave.dispose();
    });
  }

  void controlAnimation() {
    var dt = const Duration(milliseconds: 2);
    var dt2 = const Duration(milliseconds: 200);
    _controller.forward().then(
          (_) => Future.delayed(dt).then(
            (_) => _controller.reverse().then(
                  (_) => workFinish().then(
                    (_) => Future.delayed(dt2).then(
                      (_) => controlAnimation(),
                    ),
                  ),
                ),
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var wave in waves) {
      wave.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    const playFont =
        TextStyle(fontSize: 40, color: Color.fromARGB(255, 31, 111, 230));
    var button = GestureDetector(
      onTap: () => context.push('/constructor'),
      child: Container(
        key: buttonKey,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(shape: BoxShape.circle, color: btnColor),
        width: size.width / 2,
        height: size.width / 2,
        child: const Center(child: Text('P l a y', style: playFont)),
      ),
    );
    return CustomPaint(
      painter: WavesPainter(waves),
      child: Center(
        child: ScaleTransition(scale: animation, child: button),
      ),
    );
  }
}

class MainPageWaveDescription implements WaveDescription {
  final AnimationController _controller;

  @override
  Animation? colorAnimation;

  @override
  Animation? radiusAnimation;

  @override
  Offset center;

  MainPageWaveDescription(
    this._controller,
    double radius,
    this.center, {
    color = Colors.redAccent,
    double startRadius = 0,
  }) {
    radiusAnimation =
        Tween(begin: startRadius, end: radius).animate(_controller);
    colorAnimation = ColorTween(
      begin: color,
      end: const Color.fromARGB(255, 219, 216, 216).withAlpha(0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInCirc),
    );
  }

  @override
  dispose() => _controller.dispose();
}
