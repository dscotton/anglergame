/**
 *  This file contains relevant code for ExploreMode actions and interactions that need to be tracked and animated.
 */

part of angler_game;

abstract class Action {
  Vector2 loc;
  int frame;
  Action(this.loc, this.frame);
  void draw(CanvasRenderingContext2D ctx);
}

abstract class LinearAction extends Action {
  Vector2 end_loc;
  LinearAction(loc, this.end_loc, frame) : super(loc, frame);
}

class SpinAttack extends Action {
  SpinAttack(loc, frame) : super(loc, frame);
  void draw(CanvasRenderingContext2D ctx) {
    ctx.strokeText("SPIN!", loc.x, loc.y);
  }
}

class BasicAttack extends LinearAction {
  BasicAttack(loc, end_loc, frame) : super(loc, end_loc, frame);
  void draw(CanvasRenderingContext2D ctx) {
    ctx.beginPath();
    ctx.moveTo(loc.x, loc.y);
    ctx.lineTo(end_loc.x, end_loc.y);
    ctx.closePath();
    ctx.stroke();
    ctx.strokeText("HIT!", end_loc.x, end_loc.y);
  }
}

class ThrowAttack extends LinearAction {
  ThrowAttack(loc, end_loc, frame) : super(loc, end_loc, frame);
  void draw(CanvasRenderingContext2D ctx) {
    ctx.beginPath();
    ctx.moveTo(loc.x, loc.y);
    ctx.lineTo(end_loc.x, end_loc.y);
    ctx.closePath();
    ctx.stroke();
    ctx.strokeText("THROW!", end_loc.x, end_loc.y);
  }
}