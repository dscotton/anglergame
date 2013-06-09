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
 * starting the game if the player hits Enter or clicks on the screen.
 */
class TitleMode extends GameMode {
  static final String TITLE_IMAGE = 'images.title';

  AssetManager assetManager;
  ImageElement titleScreen;

  TitleMode(this.assetManager) {
    titleScreen = assetManager['images.title'];
  }

  onUpdate(GameLoopHtml gameLoop) {
    if (gameLoop.keyboard.pressed(Keyboard.ENTER) ||
        gameLoop.mouse.released(0) ) {
      throw new ModeChangeException(ModeChangeException.EXPLORE_MODE);
    }
  }

  onRender(CanvasRenderingContext2D ctx) {
    ctx.drawImage(titleScreen, 0, 0);
    ctx.stroke();
  }
}

// Helper class used in ExploreMOde
class Tap {
  Vector loc;
  Sprite stickied_to;
  int frame;
  Tap(x, y, this.frame) {
    loc = new Vector(x, y);
  }
}

/**
 * This is the 2d overhead mode in which exploration takes place.
 */
class ExploreMode extends GameMode {
  AssetManager assetManager;
  Player player;
  List mobs;
  List immobs;
  Tap last_tap = null;

  ExploreMode(this.assetManager) { 
    mobs = new List();
    immobs = new List();
    // Debug code. We're going to create a character, an enemy, and an interactable.
    player = new Player(20, 100, assetManager['images.explore_dbg_player']);
    
    Mobile dbg_mobile = new Mobile(100, 20, assetManager['images.explore_dbg_mob']);
    mobs.add(dbg_mobile);
    
    Immobile dbg_immobile = new Immobile(100, 180, assetManager['images.explore_dbg_immob']);
    immobs.add(dbg_immobile);
  }

  onUpdate(GameLoopHtml gameLoop) {
    // Record a tap.
    if (gameLoop.mouse.released(0)) {
      Tap new_tap = new Tap(gameLoop.mouse.x, gameLoop.mouse.y, gameLoop.frame);
      // [NYI] Expire last tap. Just always expire for now.
      last_tap = null;
      if (last_tap == null) {
        // No previous action.
        // [NYI] Sticky to nearby element.
        // No nearby element, this is a movement command.
        player.destination = new_tap.loc;
      }
      last_tap = new_tap;
    }
    // Collision check the player.
    mobs.forEach((mob) => player.collidesWith(mob));
    immobs.forEach((immob) => player.collidesWith(immob));
    
    // Move the player.
    player.Move();
    
    // [NYI] Move the mobs.
  }

  onRender(CanvasRenderingContext2D ctx) {
    // Debug code. Write the mode and some debug information.
    ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);
    ctx.strokeText("ExploreMode", 10, 10);
        
    // Draw the environment
    
    // Draw immobile objects
    immobs.forEach((immob) => ctx.drawImage(immob.image, immob.rect.left, immob.rect.top));
    
    // Draw mobile objects
    mobs.forEach((mob) => ctx.drawImage(mob.getImage(), mob.rect.left, mob.rect.top));

    // Draw the player.
    ctx.drawImage(player.getImage(), player.rect.left, player.rect.top);
  }
}

/**
 * Boss battle mode where you time button presses to prepare a meal.
 */
class CookMode extends GameMode {
  AssetManager assetManager;

  /*
   * Graphically this mode needs several elements:
   * - A background image (probably generated from tiles but should only be
   *   rendered once per area).
   * - An enemy sprite.  This will have some animations but no gameplay logic
   *   except possibly charging the player when time runs out.
   * - A player sprite.  This also should have some animations but they will
   *   respond to game state (combo effectiveness) rather than directly to
   *   player actions.
   * - A rhythm status timer showing when buttons should be pressed.
   * - Text boxes that pop up to indicate successfulness of combos.
   *
   * The data should just be an array (or array of arrays) of buttons that
   * need to be pressed and timings before pressing them, along with potential
   * score for each.  Big open question: how will these be generated,
   * since the items are based on user inventory selection?  Do bosses
   * have their own Rhythms, are the timings always constant, or what?
   */

  CookMode(this.assetManager);

  /**
   * Initialize and begin a particular battle.
   */
  startBattle(int area) {

  }

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