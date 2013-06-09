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
  Vector destination;
  Creature(int x, int y, image) : super(x, y, image);
  void MoveToward(Vector v, int distance) {
    Vector delta = v - loc;
    int delta_mag = delta.magnitude;
    if (delta_mag <= distance) {
      // Arrive
      rect.left += delta.x;
      rect.top += delta.y;
    } else {
      // Get closer
      rect.left += (delta.x * (distance / delta_mag)).floor();
      rect.top += (delta.y * (distance / delta_mag)).floor();
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

/**
 * Simple 2 dimensional vector containing an x and y component.
 */
class Vector {
  int x;
  int y;

  Vector(this.x, this.y);
  int get magnitude => sqrt(x * x + y * y).floor();
  bool operator ==(Vector v) {
    return (x == v.x && y == v.y);
  }
  Vector operator +(Vector v) {
    return new Vector(x + v.x, y + v.y);
  }
  Vector operator -(Vector v) {
    return new Vector(x - v.x, y - v.y);
  }
}

// The player object
class Player extends Creature {
  static final int STEPS_PER_TICK = 10;
  Player(int x, int y, image) : super(x, y, image);
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