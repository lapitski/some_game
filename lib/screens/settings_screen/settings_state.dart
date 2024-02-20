import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsProvider =
    StateNotifierProvider<SettingsStateNotifier, SettingsState>(
        (ref) => SettingsStateNotifier());

class SettingsState {
  bool showControls = false;
  bool playSounds = true;
  String character = 'Ninja Frog';

  SettingsState({
    this.showControls = false,
    this.playSounds = true,
    this.character = 'Ninja Frog',
  });

  SettingsState copyWith({
    bool? showControls,
    bool? playSounds,
    String? character,
  }) {
    return SettingsState(
      showControls: showControls ?? this.showControls,
      playSounds: playSounds ?? this.playSounds,
      character: character ?? this.character,
    );
  }
}

class SettingsStateNotifier extends StateNotifier<SettingsState> {
  SettingsStateNotifier() : super(SettingsState());

  toggleShowControls() {
    state = state.copyWith(showControls: !state.showControls);
  }

  togglePlaySounds() {
    state = state.copyWith(playSounds: !state.playSounds);
  }

  setCharacter(String name) {
    state = state.copyWith(character: name);
  }
}
