import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  late TiledComponent level;
  @override
  FutureOr<void> onLoad() async{

    level = await TiledComponent.loa
    return super.onLoad();
  }
}
