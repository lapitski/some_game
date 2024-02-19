import 'dart:async';

import 'package:flame/components.dart';

class LevelTimer extends TextComponent {
  int seconds;

  LevelTimer({
    this.seconds = 0,
    super.position,
    super.size,
  });

  @override
  FutureOr<void> onLoad() {
    text = _printDuration();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    text = _printDuration();
    super.update(dt);
  }

  String _printDuration() {
    Duration duration = Duration(seconds: seconds);
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
