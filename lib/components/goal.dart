import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:some_game/components/custom_hitbox.dart';
import 'package:some_game/components/some_game.dart';

class Goal extends SpriteAnimationComponent
    with HasGameRef<SomeGame>, CollisionCallbacks {
  String goal;
  String path;
  Vector2 textureSize;
  Goal({
    this.goal = '',
    this.path = 'Items/Fruits',
    position,
    size,
    required this.textureSize,
  }) : super(
          position: position,
          size: size,
        );

  final stepTime = 0.05;

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('$path/$goal.png'),
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: stepTime,
          textureSize: textureSize,
        ));
    return super.onLoad();
  }

  void updateGoal(String name) async {
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('$path/$name.png'),
        SpriteAnimationData.sequenced(
          loop: false,
          amount: 1,
          stepTime: stepTime,
          textureSize: textureSize,
        ));

    await animationTicker?.completed;
  }
}
