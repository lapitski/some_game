import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:some_game/components/some_game.dart';

class JumpButton extends SpriteComponent with HasGameRef<SomeGame>, TapCallbacks{
  JumpButton();

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('HUD/jump.png'));
    position = Vector2(
      game.size.x - 32 - 64,
      game.size.y - 32 - 64,
      
    );
    priority = 10;
    return super.onLoad();
  }
  @override
  void onTapDown(TapDownEvent event) {
    game.playSound('jump.wav');
   
  game.player.hasJumped = true;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
   game.player.hasJumped = false;
    super.onTapUp(event);
  }
}
