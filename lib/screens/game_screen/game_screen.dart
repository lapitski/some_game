import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_game/components/some_game.dart';
import 'package:some_game/screens/settings_screen/settings_state.dart';
import 'package:some_game/screens/settings_screen/widgets.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    var settings = ref.read(settingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Play')),
      body: GameWidget(
        game: SomeGame(
          currentLevel: 0,
          playSounds: settings.playSounds,
          player: availablePlayers[settings.character]!,
          showControls: settings.showControls,
        ),
        initialActiveOverlays: ['Settings'],
        loadingBuilder: (context) {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
        overlayBuilderMap: {
          'Settings': (context, SomeGame game) {
            return GameScreenSettings(
              game: game,
            );
          }
        },
      ),
    );
  }
}

class GameScreenSettings extends ConsumerWidget {
  final SomeGame game;
  const GameScreenSettings({required this.game, super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SettingsLine(
          '',
          Icon(
            ref.watch(settingsProvider).showControls
                ? Icons.gamepad
                : Icons.keyboard,
            color: Colors.white60,
          ),
          onSelected: () {
            game.toggleControls();
            ref.read(settingsProvider.notifier).toggleShowControls();
          },
        ),
        SettingsLine(
          '',
          Icon(
            ref.watch(settingsProvider).playSounds
                ? Icons.music_note
                : Icons.music_off,
            color: Colors.white60,
          ),
          onSelected: () {
            game.playSounds = !game.playSounds;
            ref.read(settingsProvider.notifier).togglePlaySounds();
          },
        )
      ],
    );
  }
}
