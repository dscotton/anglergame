part of angler_game;

/**
 * Represents a rectangle with x and y position.
 */
class Rect {
  num left;
  num top;
  num width;
  num height;

  Rect(this.left, this.top, this.width, this.height);
  
  Rect.bounding_box(Vector2 start, Vector2 end) {
    width = (end.x - start.x).abs();
    height = (end.y - start.y).abs();
    left = math.min(start.x, end.x).abs();
    top = math.min(start.y, end.y).abs();
  }

  num get right => left + width;
  num get bottom => top + height;
  num get center_x => (left + width / 2).floor();
  num get center_y => (top + height / 2).floor();
  num get radius => math.sqrt((math.pow(width, 2) + math.pow(height, 2)));

  /**
   * Test for collision with another sprite, assuming rectangular area for both.
   */
  bool collidesWith(Rect other) {
    return !(left >= other.right || right <= other.left
        || top >= other.bottom || bottom <= other.top);
  }
}