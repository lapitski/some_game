import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:some_game/components/background_tile.dart';
import 'package:some_game/components/checkpoint.dart';
import 'package:some_game/components/collision_block.dart';
import 'package:some_game/components/fruit.dart';
import 'package:some_game/components/goal.dart';
import 'package:some_game/components/level_timer.dart';
import 'package:some_game/components/number.dart';
import 'package:some_game/components/player.dart';
import 'package:some_game/components/saw.dart';
import 'package:some_game/components/some_game.dart';

class Level extends World with HasGameRef<SomeGame> {
  final String levelName;
  final Player player;
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  Level({required this.levelName, required this.player});
  List<String> goalList = [];
  bool isNumberLevel = false;
  List<int> numbers = [];
  List<Number> numberComponents = [];
  late Goal goal;
  int secondsElapsed = 0;
  late Timer timer;

  @override
  FutureOr<void> onLoad() async {
    timer = Timer(1, repeat: true, onTick: () {
      secondsElapsed++;
    });
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);

    _scrollingBackground();
    _spawningObjects();
    _addCollisions();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    timer.update(dt);
    var levelTimer = firstChild<LevelTimer>();

    levelTimer?.seconds = secondsElapsed;
    super.update(dt);
  }

  void _scrollingBackground() {
    final backroundLayer = level.tileMap.getLayer('Background');
    if (backroundLayer != null) {
      final backgroundColor =
          backroundLayer.properties.getValue('Backgroundcolor');
      final backroundTile = BackgroundTile(
          color: backgroundColor ?? 'Gray', position: Vector2(0, 0));
      add(backroundTile);
    }
  }

  void _spawningObjects() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          case 'Fruit':
            final fruit = Fruit(
              fruit: spawnPoint.name,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            goalList.add(spawnPoint.name);
            add(fruit);
            break;
          case 'Number':
            final number = Number(
              number: spawnPoint.properties.getValue('value'),
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            numbers.add(number.number);
            isNumberLevel = true;
            numberComponents.add(number);
            break;
          case 'Goal':
            goal = Goal(
              goal: 'Apple',
              path: 'Items/Fruits',
              textureSize: Vector2.all(32.0),
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );

            break;
          // case 'Saw':
          //   final saw = Saw(
          //     isVertical: spawnPoint.properties.getValue('isVertical') ?? false,
          //     offNeg: spawnPoint.properties.getValue('offNeg') ?? 0,
          //     offPos: spawnPoint.properties.getValue('offPos') ?? 0,
          //     position: Vector2(spawnPoint.x, spawnPoint.y),
          //     size: Vector2(spawnPoint.width, spawnPoint.height),
          //   );
          //   add(saw);
          //   break;
          case 'Checkpoint':
            final checkpoint = Checkpoint(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(checkpoint);
            break;
          case 'Text':
            add(TextComponent(
              text: spawnPoint.name,
              scale: Vector2.all(0.6),
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            ));
            break;
          case 'Time':
            add(
              LevelTimer(
                seconds: secondsElapsed,
                position: Vector2(spawnPoint.x, spawnPoint.y),
                size: Vector2(spawnPoint.width, spawnPoint.height),
              ),
            );
            break;
          default:
        }
      }
      if (isNumberLevel) {
        numbers.sort();
        numberComponents.shuffle();
        for (var i = 0; i < numbers.length; i++) {
          numberComponents[i].number = numbers[i];
        }
        goalList = numbers.map((e) => e.toString()).toList();
        goal.goal = 'Number${goalList[0]}';
        goal.textureSize = Vector2(7.0, 10.0);
        addAll(numberComponents);
      } else {
        goalList.shuffle();
        goal.goal = goalList[0];
      }

      add(goal);
      print(goalList);
      print(goal.goal);
    }
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('collisions');
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);

            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
  }
}
