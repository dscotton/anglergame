part of angler_game;

/**
 * Represents a rectangle with x and y position.
 */
class Rect {
  int left;
  int top;
  int width;
  int height;

  Rect(this.left, this.top, this.width, this.height);

  int get right => left + width;
  int get bottom => top + height;

  /**
   * Test for collision with another sprite, assuming rectangular area for both.
   */
  bool collidesWith(Rect other) {
    return !(left > other.right || right < other.left || top > other.bottom || bottom < other.top);
  }
}