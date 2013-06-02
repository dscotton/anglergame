/**
 * This file provides a logical grouping for classes relating to "creatures",
 * entities that can move around the screen and/or take action independently.
 */

part of angler_game;

/**
 * A creature is a game entity that moves and displays an image on the screen.
 */
abstract class Creature extends Rect {

  Vector getMove();
  ImageElement getImage();
}

/**
 * Simple 2 dimensional vector containing an x magnitude and a y magnitude.
 */
class Vector {
  int x;
  int y;

  Vector(this.x, this.y);
}