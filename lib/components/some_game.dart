import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:some_game/components/player.dart';
import 'package:some_game/components/level.dart';

class SomeGame extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  late final CameraComponent cam;

  Player player = Player(character: 'Virtual Guy');
  late JoystickComponent joystick;
  final showJoystick = false;

  @override
  FutureOr<void> onLoad() async {
    //load all images into cache
    await images.loadAllImages();
    final level = Level(levelName: 'level-01', player: player);
    cam = CameraComponent.withFixedResolution(
        width: 640, height: 360, world: level);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, level]);
    if (showJoystick) {
      addJoystick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }

    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
       //player.playerDirection = PlayerDirection.left;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        //player.playerDirection = PlayerDirection.right;
        break;
      default:
        //idle
       // player.playerDirection = PlayerDirection.none;
        break;
    }
  }
}
