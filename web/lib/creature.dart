/**
 * This file provides a logical grouping for classes relating to "creatures",
 * entities that can move around the screen and/or take action independently.
 */

part of angler_game;

/**
 * A creature is a game entity capable of moving independently.
 */
abstract class Creature extends Sprite {
  final int speed = 5;  // sample speed
  Vector2 destination;
  Creature(num x, num y, image) : super(x, y, image);
  void SetDestCollisionDetect(Vector2 dest, List<Immobile> immobs) {
    Rect movement_bounding_box = new Rect.bounding_box(loc, dest);
    num blocked = 1.0;
    // TODO refactor this to clean up
    for (Immobile immob in immobs) {
      if (!immob.rect.collidesWith(movement_bounding_box)) {
        // Move is nowhere near it
        continue;
      }
      // Find nearest point to immob to check for collision there.
      Vector2 delta = dest - loc;
      Vector2 test_vector = immob.loc - loc;
      num dotproduct = delta.dot(test_vector);
      num percentage = dotproduct / delta.length2;
      if (percentage < 0.0 || percentage > 1.0) {
        // Test point is outside line segment.
        continue;
      }
      if (percentage > blocked) {
        // We'll never get here, we're blocked somewhere closer.
        continue;
      }
      Vector2 point_on_path = loc + (delta * percentage);
      num point_on_path_dist = (point_on_path - immob.loc).length;
      if (point_on_path_dist > immob.rect.radius && point_on_path_dist > rect.radius) {
        // Outside any possible collision range.
        continue;
      }
      // We could be blocked on this immob; have to do a detailed check.
      // Generate four transposition vectors based on rect's four corners + delta.
      // This algorithm breaks when we have to detect running into things smaller than this.
      blocked = immob.CheckVectorCollision(this.rect, delta);
    }
    if (blocked >= 1.0) {
      destination = dest;
    } else {
      // Clean the percentage a little.
      double cleaned_percentage = (blocked * 100).floorToDouble() / 100;
      destination = loc + (dest - loc).scale(cleaned_percentage);
    }
  }
  void MoveToward(Vector2 v, num distance) {
    Vector2 delta = v - loc;
    double delta_mag = delta.length;
    if (delta_mag <= distance) {
      // Arrive
      rect.left += delta.x;
      rect.top += delta.y;
    } else {
      // Get closer
      rect.left += (delta.x * (distance / delta_mag));
      rect.top += (delta.y * (distance / delta_mag));
    }
  }
  void Move() {
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
  List<Ingredient> inventory;
  List<List<Ingredient>> equipped;

  Player(num x, num y, image) : super(x, y, image) {
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
  Mobile(num x, num y, image) : super(x, y, image);
  ImageElement getImage() {
    return this.image;
  }
}

// A static interactable object
class Immobile extends Sprite {
  Immobile(num x, num y, image) : super(x, y, image);
  
}