part of angler_game;

/**
 * A Sprite is the most basic interactive entity that can be placed on screen.
 */
class Sprite {
  Rect rect;
  ImageElement image;

  Sprite(int x, int y, this.image) {
    rect = new Rect(x, y, image.width, image.height);
  }
  Sprite.fromRect(this.rect, this.image);
  Vector2 get loc => new Vector2(rect.center_x.toDouble(), rect.center_y.toDouble());
  bool collidesWith(Sprite other) {
    return rect.collidesWith(other.rect);
  }
  bool crossLeft(Vector2 start, Vector2 end) {
    return crossBorder(new Vector2(rect.left.toDouble(), rect.top.toDouble()),
        new Vector2(rect.left.toDouble(), rect.bottom.toDouble()), start, end);
  }
  bool crossTop(Vector2 start, Vector2 end) {
    return crossBorder(new Vector2(rect.left.toDouble(), rect.top.toDouble()),
        new Vector2(rect.right.toDouble(), rect.top.toDouble()), start, end);
  }
  bool crossRight(Vector2 start, Vector2 end) {
    return crossBorder(new Vector2(rect.right.toDouble(), rect.top.toDouble()),
        new Vector2(rect.right.toDouble(), rect.bottom.toDouble()), start, end);
  }
  bool crossBottom(Vector2 start, Vector2 end) {
    return crossBorder(new Vector2(rect.left.toDouble(), rect.bottom.toDouble()),
        new Vector2(rect.right.toDouble(), rect.bottom.toDouble()), start, end);
  }
  bool crossBorder(Vector2 my_start, Vector2 my_end, Vector2 test_start, Vector2 test_end) {
    // I saw this math on StackOverflow therefore it cannot be wrong.
    double x00 = test_start.x;
    double x01 = test_end.x;
    double x10 = my_start.x;
    double x11 = my_end.x;
    double y00 = test_start.y;
    double y01 = test_end.y;
    double y10 = my_start.y;
    double y11 = my_end.y;
    double det = x11 * y01 - x01 * y11;
    if (det == 0) {
      return false;
    }
    double s = (1 / det) * ((x00 - x10) * y01 - (y00 - y10) * x01);
    double t = (1 / det) * -1 * (-1 * (x00 - x10) * y11 + (y00 - y10) * x11);
    return 0 <= s && s <= 1 && 0 <= t && t <= 1;
  }
}