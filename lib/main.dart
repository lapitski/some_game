import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:some_game/components/some_game.dart';
import 'package:some_game/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  SomeGame game = SomeGame();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
theme: flutterNesTheme().copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.greenAccent,
                background: Colors.green,
              ),
              textTheme: GoogleFonts.pressStart2pTextTheme().apply(
                bodyColor:Colors.black54,
                displayColor: Colors.black54,
              ),
            ),
    );
  }
}
