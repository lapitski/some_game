import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/painting.dart';


class BackgroundTile extends ParallaxComponent {
  final String color;
  BackgroundTile({this.color = 'Gray', position})
      : super(
          position: position,
        );

  final scrollSpeed = 20.0;

  @override
  FutureOr<void> onLoad() async {
    priority = -10;
    size = Vector2.all(64); //add 0.6 to hide lines between

    parallax = await game.loadParallax(
      [ParallaxImageData('Background/$color.png')],
      baseVelocity: Vector2(0, -scrollSpeed),
      repeat: ImageRepeat.repeat,
      fill: LayerFill.none,
    );

    return super.onLoad();
  }

 
}
