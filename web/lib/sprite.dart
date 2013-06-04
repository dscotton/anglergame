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

  bool collidesWith(Sprite other) {
    return rect.collidesWith(other.rect);
  }
}