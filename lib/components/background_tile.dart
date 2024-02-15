import 'dart:async';

import 'package:flame/components.dart';
import 'package:some_game/components/some_game.dart';

class BackgroundTile extends SpriteComponent with HasGameRef<SomeGame>{
  final String color;
  BackgroundTile({this.color = 'Gray', position})
      : super(
          position: position,
        );
 
final scrollSpeed = 0.4;

        @override
  FutureOr<void> onLoad() {
    priority = -1;
   size = Vector2.all(65); //add 0.6 to hide lines between
   sprite = Sprite(game.images.fromCache('Background/$color.png'));
    return super.onLoad();
  }

  @override
  void update(double dt) {
  position.y += scrollSpeed;
  var tileSize = 64.0;
  var scrollHeight = (game.size.y/tileSize).floor();
  if (position.y > scrollHeight*tileSize) {
    position.y = -tileSize;
  }
    super.update(dt);
  }
}
