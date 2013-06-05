/**
 * Game modes are different modes of operation the game can be in.  Each mode
 * possesses its own logic for handling player input and rendering the screen.
 */

part of angler_game;

abstract class GameMode {
  void onUpdate(GameLoopHtml gameLoop);
  void onRender(CanvasRenderingContext2D ctx);
}

class TitleMode extends GameMode {
  static final String TITLE_IMAGE = 'images.title';

  AssetManager assetManager;
  ImageElement titleScreen;

  TitleMode(this.assetManager) {
    titleScreen = assetManager['images.title'];
  }

  onUpdate(GameLoopHtml gameLoop) {
    // TODO(dscotton): Handle the player starting the game by throwing an
    // exception that indicates what mode to move to.
  }

  onRender(CanvasRenderingContext2D ctx) {
    ctx.drawImage(titleScreen, 0, 0);
    ctx.stroke();
  }
}