/**
 * Game modes are different modes of operation the game can be in.  Each mode
 * possesses its own logic for handling player input and rendering the screen.
 */

part of angler_game;

abstract class GameMode {
  void onUpdate(GameLoopHtml gameLoop);
  void onRender(CanvasRenderingContext2D ctx);
}

class ModeChangeException implements Exception {
  // List all possible modes here.
  static const String TITLE_MODE = 'TitleMode';
  static const String EXPLORE_MODE = 'ExploreMode';
  static const String COOK_MODE = 'CookMode';
  static const String MENU_MODE = 'MenuMode';
  static const String PAUSE_MODE = 'PauseMode';

  final String message;

  const ModeChangeException(this.message);
}

/**
 * This is the mode used by the title screen of the game.
 *
 * At the moment it only supports displaying a title screen image, and
 * starting the game if the player hits Enter.
 */
class TitleMode extends GameMode {
  static final String TITLE_IMAGE = 'images.title';

  AssetManager assetManager;
  ImageElement titleScreen;

  TitleMode(this.assetManager) {
    titleScreen = assetManager['images.title'];
  }

  onUpdate(GameLoopHtml gameLoop) {
    if (gameLoop.keyboard.pressed(Keyboard.ENTER)) {
      throw new ModeChangeException(ModeChangeException.EXPLORE_MODE);
    }
  }

  onRender(CanvasRenderingContext2D ctx) {
    ctx.drawImage(titleScreen, 0, 0);
    ctx.stroke();
  }
}

class ExploreMode extends GameMode {
  AssetManager assetManager;

  ExploreMode(this.assetManager);

  onUpdate(GameLoopHtml gameLoop) {
    // TODO: Implement game update logic here.
  }

  onRender(CanvasRenderingContext2D ctx) {
    // TODO: Implement game drawing logic here.
  }
}

class CookMode extends GameMode {
  AssetManager assetManager;

  CookMode(this.assetManager);

  onUpdate(GameLoopHtml gameLoop) {
    // TODO: Implement game update logic here.
  }

  onRender(CanvasRenderingContext2D ctx) {
    // TODO: Implement game drawing logic here.
  }
}

class PauseMode extends GameMode {
  AssetManager assetManager;

  PauseMode(this.assetManager);

  onUpdate(GameLoopHtml gameLoop) {
    // TODO: Implement game update logic here.
  }

  onRender(CanvasRenderingContext2D ctx) {
    // TODO: Implement game drawing logic here.
  }
}

class MenuMode extends GameMode {
  AssetManager assetManager;

  MenuMode(this.assetManager);

  onUpdate(GameLoopHtml gameLoop) {
    // TODO: Implement game update logic here.
  }

  onRender(CanvasRenderingContext2D ctx) {
    // TODO: Implement game drawing logic here.
  }
}