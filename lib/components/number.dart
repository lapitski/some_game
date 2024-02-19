import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:some_game/components/custom_hitbox.dart';
import 'package:some_game/components/some_game.dart';

class Number extends SpriteAnimationComponent
    with HasGameRef<SomeGame>, CollisionCallbacks {
   int number;
  Number({this.number = 1, position, size})
      : super(position: position, size: size);

  final stepTime = 0.05;
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 3,
    offsetY: 3,
    width: 7,
    height: 10,
  );

  @override
  FutureOr<void> onLoad() {
    priority=-1;
    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/Number$number 7x10.png'),
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: stepTime,
          textureSize: Vector2(7.0, 10.0),
        ));
    return super.onLoad();
  }

  void collidedWithPlayer() async {
      game.playSound('pickupCoin.wav');
    
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/Collected.png'),
        SpriteAnimationData.sequenced(
          loop: false,
          amount: 17,
          stepTime: stepTime,
          textureSize: Vector2.all(32.0),
        ));

    await animationTicker?.completed;

    removeFromParent();
  }
}
