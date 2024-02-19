import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:some_game/components/some_game.dart';

class Saw extends SpriteAnimationComponent with HasGameRef<SomeGame> {
  final bool isVertical;
  final double offNeg;
  final double offPos;

  Saw(
      {required this.isVertical,
      required this.offNeg,
      required this.offPos,
      position,
      size})
      : super(position: position, size: size);

  static const spinSpeed = 0.1;
  static const movespeed = 50;
  static const tileSize = 16;
  double moveDirection = 1;
  double rangeNeg = 0;
  double rangePos = 0;
  @override
  FutureOr<void> onLoad() {
    add(
      CircleHitbox(
        position: Vector2(16.0, 19.0),
        radius: 19,
        collisionType: CollisionType.passive,
        anchor: Anchor.center,
        isSolid: true,
      ),
    );

    priority = -1;
    if (isVertical) {
      rangeNeg = position.y - offNeg * tileSize;
      rangePos = position.y + offPos * tileSize;
    } else {
      rangeNeg = position.x - offNeg * tileSize;
      rangePos = position.x + offPos * tileSize;
    }

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Saw/On (38x38).png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: spinSpeed,
        textureSize: Vector2.all(38.0),
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isVertical) {
      _moveVertically(dt);
    } else {
      _moveHorizontally(dt);
    }

    super.update(dt);
  }

  void _moveVertically(double dt) {
    if (position.y >= rangePos) {
      moveDirection = -1;
    } else if (position.y <= rangeNeg) {
      moveDirection = 1;
    }
    position.y += moveDirection * movespeed * dt;
  }

  void _moveHorizontally(double dt) {
    if (position.x <= rangeNeg) {
      moveDirection = 1;
    } else if (position.x >= rangePos) {
      moveDirection = -1;
    }

    position.x += moveDirection * movespeed * dt;
  }
}
