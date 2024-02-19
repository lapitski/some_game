import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:some_game/components/some_game.dart';

enum CheckpointState { noFlag, flagOut, idle }

class Checkpoint extends SpriteAnimationGroupComponent
    with HasGameRef<SomeGame>, CollisionCallbacks {
  

  Checkpoint({ position, size})
      : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    add(
      RectangleHitbox(
        position: Vector2(14, 40),
        size: Vector2(10, 10),
        collisionType: CollisionType.passive,
      ),
    );

    priority = -1;
    animations = {
      CheckpointState.noFlag: SpriteAnimation.fromFrameData(
        game.images
            .fromCache('Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png'),
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 0.1,
          textureSize: Vector2.all(64.0),
        ),
      ),
      CheckpointState.flagOut: SpriteAnimation.fromFrameData(
        game.images.fromCache(
            'Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png'),
        SpriteAnimationData.sequenced(
          amount: 26,
          stepTime: 0.03,
          textureSize: Vector2.all(64.0),
          loop: false,
        ),
      ),
      CheckpointState.idle: SpriteAnimation.fromFrameData(
        game.images.fromCache(
            'Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png'),
        SpriteAnimationData.sequenced(
          amount: 10,
          stepTime: 0.1,
          textureSize: Vector2.all(64.0),
        ),
      ),
    };

    current = CheckpointState.noFlag;

    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) async {
    if (game.player.goalsDone &&
        current == CheckpointState.noFlag) {
      game.playSound('checkpoint.wav');

      current = CheckpointState.flagOut;
      await Future.delayed(const Duration(milliseconds: 1500));
      current = CheckpointState.idle;
      game.nextLevel();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
