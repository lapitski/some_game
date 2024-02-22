import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/widgets.dart';
import 'package:some_game/components/jump_button.dart';
import 'package:some_game/components/player.dart';
import 'package:some_game/components/level.dart';

final Map<String, Player> availablePlayers = {
  'Ninja Frog': Player(character: 'Ninja_Frog', idleAmount: 11, runAmount: 12),
  'Pink Monster':
      Player(character: 'Pink_Monster', idleAmount: 4, runAmount: 6),
};

class SomeGame extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  late CameraComponent cam;
  late Level level;
  String playerId;
  late Player player;
  late JoystickComponent joystick;
  var jumpButton = JumpButton();
  var showControls = false;
  var playSounds = true;
  final volume = 1.0;
  List<String> levels = ['level-01', 'level-04'];
  var currentLevel = 0;

  SomeGame({
    required this.playerId,
    required this.showControls,
    required this.playSounds,
    required this.currentLevel,
  });

  @override
  FutureOr<void> onLoad() async {
    //load all images into cache

    await images.loadAllImages();

    _createLevelAndCamera();
    if (showControls) {
      addControls();
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoystick();
    }

    super.update(dt);
  }

  void addControls() {
    joystick = JoystickComponent(
      priority: 100,
      knob: SpriteComponent(
        priority: 100,
        sprite: Sprite(
          images.fromCache('HUD/knob.png'),
        ),
      ),
      background: SpriteComponent(
        priority: 100,
        sprite: Sprite(
          images.fromCache('HUD/joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
      children: [],
    );
    cam.viewport.add(joystick);
    cam.viewport.add(jumpButton);
  }

  toggleControls() {
    if (showControls) {
       cam.viewport.remove(joystick);
       cam.viewport.remove(jumpButton);
      showControls = false;
    } else {
      addControls();
      showControls = true;
    }
  }

  void updateJoystick() {
    player.horizontalMovement = 0;
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;

      default:
        break;
    }
  }

  nextLevel() {
    player.resetPlayer();
    cam.setRemoved();
    removeWhere((component) => component is Level);
    if (currentLevel == levels.length - 1) {
      currentLevel = 0;
    } else {
      currentLevel++;
    }
    _createLevelAndCamera();
    player.hasReachedFlag = false;
    if (showControls) {
      addControls();
    }
  }

  playSound(String file) {
    if (playSounds) {
      FlameAudio.play(file, volume: volume);
    }
  }

  void _createLevelAndCamera() {
    player = Player(
        character: availablePlayers[playerId]!.character,
        idleAmount: availablePlayers[playerId]!.idleAmount,
        runAmount: availablePlayers[playerId]!.runAmount);
    level = Level(levelName: levels[currentLevel], player: player);
    cam = CameraComponent.withFixedResolution(
        width: 640, height: 360, world: level);
    cam.viewfinder.anchor = Anchor.topLeft;
    // cam.follow(
    //   player,
    // );
    addAll([cam, level]);
  }

  resetGame() {
    player.resetPlayer();
    level.removeWhere((component) => component is Player);
    removeWhere((component) => component is Level);
  }

  @override
  void onDispose() {
    super.onDispose();
  }
}
