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
  static const String GAME_OVER_MODE = "GameOverMode";

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

// Helper class used in ExploreMode for a locational input.
class Tap {
  final int STICKINESS = 10;
  Vector loc;
  Sprite target = null;
  int frame;
  Tap(x, y, this.frame) {
    loc = new Vector(x, y);
  }
  bool StickTo(Sprite near) {
    if (near.rect.left - STICKINESS < loc.x && loc.x < near.rect.right + STICKINESS &&
        near.rect.top - STICKINESS < loc.y && loc.y < near.rect.bottom + STICKINESS) {
      target = near;
      return true;
    }
    return false;
  }
}

/**
 * This is the 2d overhead mode in which exploration takes place.
 */
class ExploreMode extends GameMode {
  final int TAP_TIMEOUT = 30;
  final int ACTION_ANIMATION = 30;
  AssetManager assetManager;
  Player player;
  List mobs;
  List immobs;
  List actions;
  Tap last_tap = null;
  Tap new_tap = null;

  ExploreMode(this.assetManager) {
    mobs = new List();
    immobs = new List();
    actions = new List();
    // Debug code. We're going to create a character, an enemy, and an interactable.
    player = new Player(20, 100, assetManager['images.explore_dbg_player']);

    Mobile dbg_mobile = new Mobile(100, 20, assetManager['images.explore_dbg_mob']);
    mobs.add(dbg_mobile);

    Immobile dbg_immobile = new Immobile(100, 180, assetManager['images.explore_dbg_immob']);
    immobs.add(dbg_immobile);
  }

  onUpdate(GameLoopHtml gameLoop) {
    // Expire last tap.
    if (last_tap != null && last_tap.frame < gameLoop.frame - TAP_TIMEOUT) {
      last_tap = null;
    }
    // Expire actions
    actions.removeWhere((action) => action.frame < gameLoop.frame - ACTION_ANIMATION);
    // Record a tap.
    if (gameLoop.mouse.released(0)) {
      new_tap = new Tap(gameLoop.mouse.x, gameLoop.mouse.y, gameLoop.frame);
      // See if new_tap has a target.
      // Target priority is mobs, then player, then immobs.
      for (final mob in mobs) {
        if (new_tap.StickTo(mob)) {
          break;
        }
      }
      if (new_tap.target == null) {
        new_tap.StickTo(player);
      }
      if (new_tap.target == null) {
        for (final immob in immobs) {
          if (new_tap.StickTo(immob)) {
            break;
          }
        }
      }
      if (new_tap.target == null) {
        // No nearby element, this is a movement command.
        player.destination = new_tap.loc;
      }
      if (last_tap == null && new_tap.target != null) {
        // Just stick last_tap and move on with life.
        last_tap = new_tap;
      } else if (last_tap != null && new_tap.target != null) {
        if (last_tap.target == player && new_tap.target == player) {
          // Player double-tap, spin attack.
          actions.add(new SpinAttack(player.loc, gameLoop.frame));
        } else if (last_tap.target == player) {
          // Player->Object, normal attack.
          actions.add(new BasicAttack(player.loc, new_tap.target.loc, gameLoop.frame));
        } else if (last_tap.target != new_tap.target && new_tap.target != player) {
          // Object->Object, throw
          actions.add(new ThrowAttack(last_tap.target.loc, new_tap.target.loc, gameLoop.frame));
        }
      }
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

    // If we have a recently selected object, highlight it.
    // This should be a little "ping" animation, ideally.
    if (last_tap != null && last_tap.target != null) {
      Sprite select = last_tap.target;
      ctx.strokeRect(select.rect.left - 2, select.rect.top - 2, select.rect.width + 4, select.rect.height + 4);
    }

    // Draw actions.
    actions.forEach((action) => action.draw(ctx));
  }
}

/**
 * Boss battle mode where you time button presses to prepare a meal.
 */
class CookMode extends GameMode {
  AssetManager assetManager;
  Player player;
  Combo currentCombo;
  int course;
  int beat;
  int frameCounter;
  double totalScore;
  Boss boss;

  Beat get currentBeat => boss.patterns[course][beat];
  List<Ingredient> get equippedIngredients => player.equipped[course];

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
   * Initialize and begin a particular battle.  This must be called before
   * you can use the mode.
   */
  startBattle(int bossNum, Player player) {
    boss = Boss.getBoss(bossNum);
    this.player = player;
    currentCombo = new Combo(boss);
    course = 0;
    beat = 0;
    totalScore = 0.0;

    // Starting with a negative frame count gives the player some time to
    // see what they need to do before immediately needing to hit buttons.
    frameCounter = -300;
  }

  onUpdate(GameLoopHtml gameLoop) {
    frameCounter++;
    if (frameCounter >= currentBeat.frames) {
      frameCounter = 0;
      beat++;
      if (beat >= boss.patterns[course].length) {
        totalScore += currentCombo.getScore();
        // TODO(dscotton): Display something about this combo on screen.
        currentCombo = new Combo(boss);
        beat = 0;
        course++;
        if (course >= boss.patterns.length) {
          if (totalScore >= boss.hitPoints) {
            throw new ModeChangeException(ModeChangeException.EXPLORE_MODE);
          } else {
            print('You lost, chump!');
            throw new ModeChangeException(ModeChangeException.GAME_OVER_MODE);
          }
        }
      }
    }

    // If the player hasn't hit this beat yet, check for input and score it.
    if (currentBeat.score == null) {
      // TODO(dscotton): Support touchscreens.
      for (int key in [Keyboard.ONE, Keyboard.TWO, Keyboard.THREE]) {
        if (key != currentBeat.button && gameLoop.keyboard.pressed(key)) {
          currentBeat.score = currentBeat.MIN_MULTIPLIER;
        }
      }
      if (gameLoop.keyboard.pressed(currentBeat.button)) {
        currentBeat.scoreBeat(frameCounter);
      }
    }
    if (currentBeat.score != null) {
      Ingredient ingredient = player.equipped[course][currentBeat.button];
      currentCombo.ingredients.add(ingredient);
      currentCombo.baseDamage += (ingredient.baseDamage * currentBeat.score);
      double multiplier = (ingredient.multiplier - 1.0) * currentBeat.score + 1.0;
      currentCombo.multiplier *= (1.0 + multiplier);
    }
  }

  onRender(CanvasRenderingContext2D ctx) {
    // TODO: Implement game drawing logic here.
    // Look ahead at the next several beats, draw a line on the screen and
    // draw some kind of indicators (color coded circles?) some appropriate
    // distance away, possibly something like # of frames away x4.
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

class GameOverMode extends GameMode {
  AssetManager assetManager;

  GameOverMode(this.assetManager);

  onUpdate(GameLoopHtml gameLoop) {
    // TODO: Implement game update logic here.
  }

  onRender(CanvasRenderingContext2D ctx) {
    // TODO: Implement game drawing logic here.
  }
}