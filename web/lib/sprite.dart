part of angler_game;

/**
 * A Sprite is the most basic interactive entity that can be placed on screen.
 */
class Sprite {
  Rect rect;
  ImageElement image;

  Sprite(num x, num y, this.image) {
    rect = new Rect(x, y, image.width, image.height);
  }
  Sprite.fromRect(this.rect, this.image);
  Vector2 get loc => new Vector2(rect.center_x.toDouble(), rect.center_y.toDouble());
  bool collidesWith(Sprite other) {
    return rect.collidesWith(other.rect);
  }
  num CheckVectorCollision(Rect r, Vector2 path) {
    Matrix2 top_left = new Matrix2(r.left, r.top, r.left + path.x, r.top + path.y);
    Matrix2 top_right = new Matrix2(r.right, r.top, r.right + path.x, r.top + path.y);
    Matrix2 bot_left = new Matrix2(r.left, r.bottom, r.left + path.x, r.bottom + path.y);
    Matrix2 bot_right = new Matrix2(r.right, r.bottom, r.right+path.x, r.bottom + path.y);
    Matrix2 top_edge = new Matrix2(rect.left, rect.top, rect.right, rect.top);
    Matrix2 left_edge = new Matrix2(rect.left, rect.top, rect.left, rect.bottom);
    Matrix2 bottom_edge = new Matrix2(rect.left, rect.bottom, rect.right, rect.bottom);
    Matrix2 right_edge = new Matrix2(rect.right, rect.top, rect.right, rect.bottom);
    num p_collision = 1.0;
    p_collision = CheckIntersection(p_collision, top_left, bottom_edge);
    p_collision = CheckIntersection(p_collision, top_left, right_edge);
    p_collision = CheckIntersection(p_collision, top_right, bottom_edge);
    p_collision = CheckIntersection(p_collision, top_right, left_edge);
    p_collision = CheckIntersection(p_collision, bot_left, top_edge);
    p_collision = CheckIntersection(p_collision, bot_left, right_edge);
    p_collision = CheckIntersection(p_collision, bot_right, top_edge);
    p_collision = CheckIntersection(p_collision, bot_right, left_edge);
    return p_collision;
  }
  num CheckIntersection(num p_collision, Matrix2 path, Matrix2 edge) {
    Vector2 p = path.getColumn(0);
    Vector2 r = path.getColumn(1) - p;
    Vector2 q = edge.getColumn(0);
    Vector2 s = edge.getColumn(1) - q;
    num rXs = r.cross(s);
    if (rXs <= 10e-6 && rXs >= -1 * 10e-6) {
      // Parallel
      return p_collision;
    }
    num t = (q - p).cross(s)/rXs;
    num u = (q - p).cross(r)/rXs;
    if (0 <= u && u <= 1 && 0 <= t && t <= 1) {
      // Does intersect, calculate intersect point.
      if (t < p_collision) {
        return t;
      }
    }
    return p_collision;
  }
}