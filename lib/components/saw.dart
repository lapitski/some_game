import 'dart:async';

import 'package:flame/components.dart';
import 'package:some_game/components/some_game.dart';

class Saw extends SpriteAnimationComponent with HasGameRef<SomeGame>{
  Saw({position, size}):super(position: position, size: size);

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(game.images.fromCache('Traps/Saw/On (32x32).png'), data)
    return super.onLoad();
  }
}