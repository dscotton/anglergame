library angler_game;

import 'dart:html';
import 'dart:math';
import 'package:asset_pack/asset_pack.dart';
import 'package:game_loop/game_loop_html.dart';

part "lib/creature.dart";
part "lib/rect.dart";
part "lib/sprite.dart";

class Game {
  AssetManager assetManager;
  CanvasElement canvas;

  Game(this.assetManager, this.canvas);

  void onUpdate(GameLoopHtml gameLoop) {
    // TODO: implement this
  }

  void onRender(GameLoopHtml gameLoop) {
    // TODO: implement this
    // This is supposed to come from GameLoopHtml, but we can't call
    // getContext on an Element.  Is there a better way to do this?
    CanvasRenderingContext2D ctx = canvas.getContext('2d');
//    AssetPack images = assetManager.loadPack('images', 'assets/images/_.pack');
    ImageElement titleScreen = assetManager['images.title'];
    ctx.drawImage(titleScreen, 0, 0);
  }
}

void main() {
  AssetManager assetManager = new AssetManager();
  CanvasElement canvas = query('#anglerGame');
  Game game = new Game(assetManager, canvas);
  GameLoopHtml gameLoop = new GameLoopHtml(canvas);
  gameLoop.onUpdate = game.onUpdate;
  gameLoop.onRender = game.onRender;
  gameLoop.start();
}
