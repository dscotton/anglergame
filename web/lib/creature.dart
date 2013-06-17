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
  Creature(int x, int y, image) : super(x, y, image);
  void SetDestCollisionDetect(Vector2 dest, List<Immobile> immobs) {
    destination = dest;
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