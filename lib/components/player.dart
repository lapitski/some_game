import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:flutter/widgets.dart';
import 'package:some_game/components/checkpoint.dart';
import 'package:some_game/components/collision_block.dart';
import 'package:some_game/components/custom_hitbox.dart';
import 'package:some_game/components/fruit.dart';
import 'package:some_game/components/goal.dart';
import 'package:some_game/components/number.dart';
import 'package:some_game/components/saw.dart';
import 'package:some_game/components/some_game.dart';
import 'package:some_game/components/utils.dart';

enum PlayerState { idle, running, jumping, falling, hit }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<SomeGame>, KeyboardHandler, CollisionCallbacks {
  String character;
  int idleAmount;
  int runAmount;
  int fallAmount;
  int jumpAmount;
  double width;
  double height;
  String? id;
  Player({
    this.id,
    this.idleAmount = 11,
    this.runAmount = 12,
    this.fallAmount = 1,
    this.jumpAmount = 1,
    this.width = 32,
    this.height = 32,
    position,
    this.character = 'Ninja_Frog',
  }) : super(position: position);

  final double stepTime = 0.1;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;

  final double _gravity = 10.8;
   double _jumpForce = 300;
  final double _terminalVelocity = 1000;
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  Vector2 startPosition = Vector2.zero();
  bool isOnGround = false;
  bool hasJumped = false;
  bool hasReachedFlag = false;
  var currentGoalIndex = 0;
  Goal? goal;

  bool goalsDone = false;
  double fallTime = 0;

  resetPlayer() {
    hasReachedFlag = false;
    currentGoalIndex = 0;
    goalsDone = false;
  }

  List<CollisionBlock> collisionBlocks = [];
  late CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 2,
    width: width-20,
    height: height-4,
  );

  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  @override
  FutureOr<void> onLoad() {
     //debugMode = true;

    //bird has less jumpForce
    if (character == availablePlayers.keys.toList()[2]) {
      _jumpForce = 150;
    }
    print('playerOnLoad');
    _loadAllAnimations();
    startPosition = Vector2(position.x, position.y);
    
    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _checkIsFalling(dt);

    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      if (current != PlayerState.hit && !hasReachedFlag) {
        _updatePlayerState();
        _updatePlayerMovement(fixedDeltaTime);
        _checkHorizontalCollisions();
        _applyGravity(fixedDeltaTime);
        _checkVerticalCollisions();
      }
      accumulatedTime -= fixedDeltaTime;
    }

    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW);

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Fruit) {
      _collisionWithFruit(other);
    } else if (other is Saw) {
      _respawn();
    } else if (other is Checkpoint) {
      if (other.current != CheckpointState.noFlag) {
        hasReachedFlag = true;
      }
    } else if (other is Number) {
      _collisionWithNumber(other);
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', idleAmount);
    runningAnimation = _spriteAnimation('Run', runAmount);
    jumpingAnimation = _spriteAnimation('Jump', jumpAmount);
    fallingAnimation = _spriteAnimation('Fall', fallAmount);
    hitAnimation = _spriteAnimation('Hit', 7)..loop = false;

    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.hit: hitAnimation,
    };

    // Set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main_Characters/$character/${state}_(32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2(width, height),
      ),
    );
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // Check if moving, set running
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    // check if Falling set to falling
    if (velocity.y > 0) playerState = PlayerState.falling;

    // Checks if jumping, set to jumping
    if (velocity.y < 0) playerState = PlayerState.jumping;

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    //Bird character can jump from air
    if (hasJumped &&
        (isOnGround || character == availablePlayers.keys.toList()[2]))
      _playerJump(dt);

    // if (velocity.y > _gravity) isOnGround = false; // optional

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    game.playSound('jump.wav');
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }

  void _respawn() async {
    if (current != PlayerState.hit) {
      game.playSound('hit.wav');

      current = PlayerState.hit;
      await Future.delayed(const Duration(milliseconds: 350));
      scale.x = 1;
      position = startPosition;
      current = PlayerState.idle;
    }
  }

  void _collisionWithNumber(Number number) {
    if (trySetNextGoal(number.number.toString())) {
      number.collidedWithPlayer();
      var goal = game.level.firstChild<Goal>();
      goal?.updateGoal(
          goalsDone
              ? 'Checkpoint_(Flag Idle)(64x64)'
              : 'Number${game.level.goalList[currentGoalIndex]}',
          updatedPath: goalsDone ? 'Items/Checkpoints/Checkpoint' : null,
          size: goalsDone ? Vector2.all(64) : null);
    }
  }

  void _collisionWithFruit(Fruit fruit) {
    if (trySetNextGoal(fruit.fruit)) {
      fruit.collidedWithPlayer();
      var goal = game.level.firstChild<Goal>();
      goal?.updateGoal(
          goalsDone
              ? 'Checkpoint_(Flag Idle)(64x64)'
              : game.level.goalList[currentGoalIndex],
          updatedPath: goalsDone ? 'Items/Checkpoints/Checkpoint' : null,
          size: goalsDone ? Vector2.all(64) : null);
    }
  }

  bool trySetNextGoal(String name) {
    if (name != game.level.goalList[currentGoalIndex]) {
      return false;
    }

    if (currentGoalIndex < game.level.goalList.length - 1) {
      currentGoalIndex++;

      print('new goal - ${game.level.goalList[currentGoalIndex]}');
    } else {
      goalsDone = true;
    }
    return true;
  }

  void _checkIsFalling(double dt) {
    //TODO: need check infinite falling
  }
}
