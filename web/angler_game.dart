library angler_game;

import 'dart:html';
import 'package:asset_pack/asset_pack.dart';
import 'package:game_loop/game_loop_html.dart';

part "lib/creature.dart";
part "lib/rect.dart";

class Game {
  AssetManager assetManager;

  Game(this.assetManager);

  void onUpdate(GameLoopHtml gameLoop) {
    // TODO: implement this
  }

  void onRender(GameLoopHtml gameLoop) {
    // TODO: implement this
  }
}

void main() {
  AssetManager assetManager = new AssetManager();
  Game game = new Game();
  CanvasElement canvas = query('#anglerGame');
  GameLoopHtml gameLoop = new GameLoopHtml(canvas);
  gameLoop.onUpdate = game.onUpdate;
  gameLoop.onRender = game.onRender;
  gameLoop.start();
}
