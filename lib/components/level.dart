import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:some_game/components/background_tile.dart';
import 'package:some_game/components/collision_block.dart';
import 'package:some_game/components/fruit.dart';
import 'package:some_game/components/player.dart';
import 'package:some_game/components/some_game.dart';

class Level extends World with HasGameRef<SomeGame> {
  final String levelName;
  final Player player;
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  Level({required this.levelName, required this.player});

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);

    _scrollingBackground();
    _spawningObjects();
    _addCollisions();

    return super.onLoad();
  }

  void _scrollingBackground() {
    final backroundLayer = level.tileMap.getLayer('Background');
    const tileSize = 64;
    final numTilesY = (game.size.y / tileSize).ceil();
    final numTilesX = (game.size.x / tileSize).floor();
    if (backroundLayer != null) {
      final backgroundColor =
          backroundLayer.properties.getValue('Backgroundcolor');

      for (var y = 0; y < numTilesY; y++) {
        for (var x = 0; x < numTilesX; x++) {
          final backroundTile = BackgroundTile(
              color: backgroundColor ?? 'Gray',
              position: Vector2((x * tileSize).toDouble(),
                  (y * tileSize).toDouble() - tileSize));
          add(backroundTile);
        }
      }
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
            add(fruit);
            break;
            case 'Saw':
            final saw
          default:
        }
      }
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
