/**
 * This file provides a logical grouping for classes relating to "creatures",
 * entities that can move around the screen and/or take action independently.
 */

part of angler_game;

/**
 * A creature is a game entity capable of moving independently.
 */
abstract class Creature extends Sprite {
  Vector getMove();
  ImageElement _getImage();
  get image => _getImage();
}

/**
 * Simple 2 dimensional vector containing an x and y component.
 */
class Vector {
  int x;
  int y;

  Vector(this.x, this.y);
  int get magnitude => sqrt(x * x + y * y);
}