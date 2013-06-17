/**
 * This file provides a logical grouping for classes relating to "creatures",
 * entities that can move around the screen and/or take action independently.
 */

part of angler_game;

/**
 * A creature is a game entity capable of moving independently.
 */
abstract class Creature extends Sprite {
  final int speed = 10;  // sample speed
  Vector2 destination;
  Creature(int x, int y, image) : super(x, y, image);
  void SetDestCollisionDetect(Vector2 dest, List<Immobile> immobs) {
    destination = dest;
    Vector2 delta = destination - loc;
    // We're checking to see if any of the corner-to-corner paths intersect any of
    // the boundry walls for each immobile object. This will fail for objects smaller
    // than the player.
    Vector2 l_t = new Vector2(rect.left.toDouble(), rect.top.toDouble());
    Vector2 r_t = new Vector2(rect.right.toDouble(), rect.top.toDouble());
    Vector2 l_b = new Vector2(rect.left.toDouble(), rect.bottom.toDouble());
    Vector2 r_b = new Vector2(rect.right.toDouble(), rect.bottom.toDouble());
    for (Immobile immob in immobs) {
      // Check if the corner vector intersects any boundry of immob; if it does, fix destination along that axis.
      if (loc.x <= destination.x &&
          (immob.crossLeft(l_t, l_t + delta) || immob.crossLeft(r_t, r_t + delta) ||
           immob.crossLeft(l_b, l_b + delta) || immob.crossLeft(r_b, r_b + delta))) {
        destination.x = immob.rect.left - (rect.width / 2) - 1; 
      }
      if (loc.y <= destination.y &&
          (immob.crossTop(l_t, l_t + delta) || immob.crossTop(r_t, r_t + delta) ||
           immob.crossTop(l_b, l_b + delta) || immob.crossTop(r_b, r_b + delta))) {
        destination.y = immob.rect.top - (rect.height / 2) - 1;
      }
      if (loc.x > destination.x &&
          (immob.crossRight(l_t, l_t + delta) || immob.crossRight(r_t, r_t + delta) ||
           immob.crossRight(l_b, l_b + delta) || immob.crossRight(r_b, r_b + delta))) {
        destination.x = immob.rect.right + (rect.width / 2) + 1; 
      }
      if (loc.y > destination.y &&
          (immob.crossBottom(l_t, l_t + delta) || immob.crossBottom(r_t, r_t + delta) ||
           immob.crossBottom(l_b, l_b + delta) || immob.crossBottom(r_b, r_b + delta))) {
        destination.y = immob.rect.bottom + (rect.height / 2) + 1;
      }
    }    
  }
  void MoveToward(Vector2 v, int distance) {
    Vector2 delta = v - loc;
    double delta_mag = delta.length;
    if (delta_mag <= distance) {
      // Arrive
      rect.left += delta.x.floor();
      rect.top += delta.y.floor();
    } else {
      // Get closer
      rect.left += (delta.x * (distance / delta_mag)).floor();
      rect.top += (delta.y * (distance / delta_mag)).floor();
    }
  }
  void Move(List<Immobile> immobs) {
    if (destination == null || loc == destination) {
      return;  // we're here, idle
    } else {
      MoveToward(destination, speed);
    }
  }
  ImageElement getImage();
  // get image => _getImage();
}

// The player object
class Player extends Creature {
  static final int STEPS_PER_TICK = 10;

  List<Ingredient> inventory;
  List<List<Ingredient>> equipped;

  Player(int x, int y, image) : super(x, y, image) {
    inventory = new List();
    equipped = new List();
  }

  ImageElement getImage() {
    return this.image;
  }

  void StopMovement() {  // indicates a safe but halting collision
    destination = null;
  }
  
  bool collidesWith(Sprite other) {
    if (super.collidesWith(other)) {
      StopMovement();
      // scoot back to clear the hitbox so we can move again
      MoveToward(other.loc, -5);
      return true;
    }
    return false;
  }
}

// A mobile interactable object
class Mobile extends Creature {
  Mobile(int x, int y, image) : super(x, y, image);
  ImageElement getImage() {
    return this.image;
  }
}

// A static interactable object
class Immobile extends Sprite {
  Immobile(int x, int y, image) : super(x, y, image);
  
}