import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_game/components/some_game.dart';
import 'package:some_game/screens/settings_screen/settings_state.dart';
import 'package:some_game/screens/settings_screen/widgets.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final playSounds = ref.watch(settingsProvider).playSounds;
    final showControls = ref.watch(settingsProvider).showControls;
    final character = ref.watch(settingsProvider).character;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 26.0),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SettingsLine(
                      'Play Sounds',
                      Icon(playSounds ? Icons.music_note : Icons.music_off),
                      onSelected:
                          ref.read(settingsProvider.notifier).togglePlaySounds,
                    ),
                    const SizedBox(height: 16.0),
                    SettingsLine(
                      'Controls/Keyboard',
                      Icon(showControls ? Icons.gamepad : Icons.keyboard),
                      onSelected: ref
                          .read(settingsProvider.notifier)
                          .toggleShowControls,
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Character:'),
                    const SizedBox(height: 8.0),
                    RadioListTile.adaptive(
                      title: Text(availablePlayers.keys.toList()[0]),
                      value: availablePlayers.keys.toList()[0],
                      groupValue: character,
                      onChanged: (name) =>
                          ref.read(settingsProvider.notifier).setCharacter(
                                name ?? availablePlayers.keys.first,
                              ),
                    ),
                    RadioListTile.adaptive(
                      title: Text(availablePlayers.keys.toList()[1]),
                      value: availablePlayers.keys.toList()[1],
                      groupValue: character,
                      onChanged: (name) =>
                          ref.read(settingsProvider.notifier).setCharacter(
                                name ?? availablePlayers.keys.first,
                              ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
