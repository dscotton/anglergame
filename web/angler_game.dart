library angler_game;

import 'dart:html';
import 'package:game_loop/game_loop_html.dart';

class Game {
  void onUpdate(GameLoopHtml gameLoop) {
    // TODO: implement this
  }

  void onRender(GameLoopHtml gameLoop) {
    // TODO: implement this
  }
}

void main() {
  Game game = new Game();
  CanvasElement canvas = query('#anglerGame');
  GameLoopHtml gameLoop = new GameLoopHtml(canvas);
  gameLoop.onUpdate = game.onUpdate;
  gameLoop.onRender = game.onRender;
  gameLoop.start();
}
