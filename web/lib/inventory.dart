/**
 * This file contains all classes related to player inventory.
 */

part of angler_game;

/**
 * An ingredient is one of the food items the player collects and uses to
 * fight boss battles.
 */
class Ingredient {
  // Elements
  static const int EARTH = 1;
  static const int AIR = 2;
  static const int FIRE = 3;
  static const int WATER = 4;
  static const int LIGHT = 5;
  static const int DARK = 6;

  // Food types
  static const int FISH = 0x10;
  static const int FRUIT = 0x11;
  static const int GROUND = 0x12;

  int baseDamage;
  int element;
  int type;
  int multiplier;

  Ingredient(this.type, this.element, this.baseDamage, [this.multiplier = 1]);
}