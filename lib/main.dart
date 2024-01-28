import 'package:fill_field/pages/modes_list/view.dart';

import 'pages/game_field/view.dart';
import 'pages/main_page/view.dart';

import 'package:fill_field/src/file_manager.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FileManager().initManager();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: navTree,
      title: "Field Filler",
    );
  }
}

final navTree = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainPageView(),
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) => GameWidget(gameMode: state.extra),
    ),
    GoRoute(
      path: '/constructor',
      builder: (context, state) => const ModesListView(),
    ),
  ],
);
