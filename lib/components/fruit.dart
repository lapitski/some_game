import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:some_game/components/custom_hitbox.dart';
import 'package:some_game/components/some_game.dart';

class Fruit extends SpriteAnimationComponent
    with HasGameRef<SomeGame>, CollisionCallbacks {
  final String fruit;
  Fruit({this.fruit = 'Apple', position, size})
      : super(position: position, size: size);

  bool _isCollected = false;
  final stepTime = 0.05;
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 10,
    width: 12,
    height: 12,
  );

  @override
  FutureOr<void> onLoad() {
    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/$fruit.png'),
        SpriteAnimationData.sequenced(
          amount: 17,
          stepTime: stepTime,
          textureSize: Vector2.all(32.0),
        ));
    return super.onLoad();
  }

  void collidedWithPlayer() async {
    if (!_isCollected) {
      animation = SpriteAnimation.fromFrameData(
          game.images.fromCache('Items/Fruits/Collected.png'),
          SpriteAnimationData.sequenced(
            loop: false,
            amount: 17,
            stepTime: stepTime,
            textureSize: Vector2.all(32.0),
          ));
      _isCollected = true;
      await Future.delayed(
        const Duration(milliseconds: 300),
      );
      removeFromParent();
    }
  }
}
