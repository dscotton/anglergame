/**
 * This file contains code related to boss battles.
 *
 * It also contains hardcoded patterns (aka rhythms) for each boss.  These
 * could be formatted as JSON and stored in assets, but at least for now
 * that just adds pointless complexity (in loading them) when they're
 * relatively simple and there's no tool for modifying them.
 */

part of angler_game;

// TODO(dscotton): Add boss animations
class Boss {
  // Bosses contain patterns for three different "courses" or combos.
  // Each course is a list of Beats.
  List<List<Beat>> patterns;

  Boss(this.patterns);

  // Hard coded boss patterns
  final Boss demon = new Boss([
      [new Beat(1, 30), new Beat(2, 30), new Beat(1, 60), new Beat(3, 30)],
  ]);
}


/**
 * A Beat is a single button press in a boss battle combo.
 *
 * Each beat has timing info associated with it, expressed in number of
 * frames of animation.  Because the game runs at 60 FPS (hopefully), 30
 * frames corresponds to a quarter note at 120 BPM.
 */
class Beat {
  // For each battle there are three ingredients. This corresponds to which
  // ingredient the player needs to use for this Beat, and which button they
  // need to press.  It should be 1, 2, or 3.
  int ingredient;
  int frames;

  Beat(this.ingredient, this.frames);
}