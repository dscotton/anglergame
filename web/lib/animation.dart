library angler_game;

import 'dart:html';

/**
 * An animation is a looping sequence of images.
 */
class Animation {
  List<ImageElement> images;
  final int frameDelay;
  int currentFrame;
  int frameCounter;

  Animation(this.images, {this.frameDelay: 1}) {
    assert(frameDelay >= 1);
    currentFrame = 0;
    frameCounter = frameDelay;
  }

  ImageElement nextFrame() {
    if (frameCounter == 0) {
      frameCounter = frameDelay;
      currentFrame++;
      if (currentFrame >= images.length) {
        currentFrame = 0;
      }
    }
    frameCounter--;
    return images[currentFrame];
  }
}