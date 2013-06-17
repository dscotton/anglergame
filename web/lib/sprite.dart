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
}