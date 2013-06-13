/**
 * This file contains all classes related to player inventory.
 */

part of angler_game;

/**
 * An ingredient is one of the food items the player collects and uses to
 * fight boss battles.
 */
class Ingredient {
  int baseDamage;
  Element element;
  FoodType type;
  int multiplier;

  Ingredient(this.type, this.element, this.baseDamage, [this.multiplier = 1]);
}

// Fake enumerations for elements and type.
class Element {
  static const EARTH = const Element._(0);
  static const AIR = const Element._(1);
  static const FIRE = const Element._(2);
  static const WATER = const Element._(3);
  static const LIGHT = const Element._(4);
  static const DARK = const Element._(5);

  static get values => [EARTH, AIR, FIRE, WATER, LIGHT, DARK];

  final int value;

  const Element._(this.value);
}

class FoodType {
  static const FISH = const FoodType._(0);
  static const FRUIT = const FoodType._(1);
  static const GROUND = const FoodType._(2);

  static get values => [FISH, FRUIT, GROUND];

  final int value;

  const FoodType._(this.value);
}