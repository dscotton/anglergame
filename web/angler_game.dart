library angler_game;

import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'package:asset_pack/asset_pack.dart';
import 'package:game_loop/game_loop_html.dart';

part "lib/creature.dart";
part "lib/game_mode.dart";
part "lib/rect.dart";
part "lib/sprite.dart";

class Game {
  AssetManager assetManager;
  CanvasElement canvas;

  // Game Modes
  GameMode currentMode;
  TitleMode titleMode;

  Game(this.assetManager, this.canvas) {
    titleMode = new TitleMode(this.assetManager);
    currentMode = titleMode;
  }

  void onUpdate(GameLoopHtml gameLoop) {
    // TODO: Implement logic for changing mode when the current mode
    // throws a ModeChangeException.
    currentMode.onUpdate(gameLoop);
  }

  void onRender(GameLoopHtml gameLoop) {
    // TODO: implement this
    // This is supposed to come from GameLoopHtml, but we can't call
    // getContext on an Element.  Is there a better way to do this?
    CanvasRenderingContext2D ctx = canvas.getContext('2d');
    currentMode.onRender(ctx);
  }
}

void main() {
  // Set up AssetManager to handle images.
  AssetManager assetManager = new AssetManager();
  assetManager.importers['image'] = new NoopImporter();
  assetManager.loaders['image'] = new ImageLoader();

  CanvasElement canvas = query('#anglerGame');

  Future<AssetPack> futureAssetPack = assetManager.loadPack(
      'images', 'assets/images/_.pack');
  futureAssetPack.then((AssetPack imagePack) {
    // This setup takes place here so assets are available to the game
    // at init time.
    // TODO(dscotton): Display a loading screen if necessary.
    Game game = new Game(assetManager, canvas);
    GameLoopHtml gameLoop = new GameLoopHtml(canvas);
    gameLoop.onUpdate = game.onUpdate;
    gameLoop.onRender = game.onRender;
    // TODO(dscotton): Figure out how to control the frame rate.
    gameLoop.start();
  },
  onError: (e) {
    print('There was an error loading assets: $e');
  });

}
