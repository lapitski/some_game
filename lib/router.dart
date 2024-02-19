import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:some_game/screens/game_screen/game_screen.dart';
import 'package:some_game/screens/main_menu_screen/main_menu_screen.dart';
import 'package:some_game/screens/settings_screen/settings_screen.dart';

class AppRoutes {
  static const home = '/';
  static const game = 'game';
  static const setting = 'settings';
}

final router = GoRouter(

  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenuScreen(key: Key('main_menu')),
     
      routes: [
        GoRoute(
          path: 'game',
          builder: (context, state) => const GameScreen(key: Key('game'),),
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsScreen(
            key: Key('settings'),
          ),
        ),
      ],
    ),
  ],
);
