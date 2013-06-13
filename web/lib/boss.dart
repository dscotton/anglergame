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
abstract class Boss {
  // Bosses contain patterns for three different "courses" or combos.
  // Each course is a list of Beats.
  List<List<Beat>> patterns;
  Map<Element, double> elementalMultipliers;

  static final Boss sunstone = new Sunstone();

  static Boss getBoss(int bossNum) {
    switch (bossNum) {
      case 1:
        return sunstone;
    }
  }

  /**
   * Get the damage multiplier for a given element against this boss.
   */
  double getMultiplier(Element element);
}


/**
 * This class represents the first Boss.  It contains hard coded data for
 * patterns and elemental weaknesses.
 */
class Sunstone extends Boss {
  static const double WEAKNESS_MULTIPLIER = 1.5;
  static final Set<Element> weaknesses = new Set.from([Element.AIR, Element.DARK]);

  Sunstone() {
    // We must initialize a new version of patterns for each instance, because
    // Beats are mutable and are modified in the course of registering scores.
    patterns = [
        [new Beat(Keyboard.ONE, 30), new Beat(Keyboard.TWO, 30),
         new Beat(Keyboard.ONE, 60), new Beat(Keyboard.THREE, 30)],
    ];
  }

  double getMultiplier(Element element) {
    if (weaknesses.contains(element)) {
      return WEAKNESS_MULTIPLIER;
    } else {
      return 1.0;
    }
  }
}


/**
 * A Beat is a single button press in a boss battle combo.
 *
 * Each beat has timing info associated with it, expressed in number of
 * frames of animation.  Because the game runs at 60 FPS (hopefully), 30
 * frames corresponds to a quarter note at 120 BPM.
 */
class Beat {
  const double MIN_MULTIPLIER = 0.5;
  const double MAX_MULTIPLIER = 1.0;
  const double PERFECTION_BONUS = 0.1;
  // Number of frames before and after that a hit will score >MIN points.
  const int FRAME_WINDOW = 10;

  // For each battle there are three ingredients. This corresponds to which
  // ingredient the player needs to use for this Beat, and which button they
  // need to press.  It should be 1, 2, or 3.
  int button;
  int frames;
  double score;

  // This represents the number of frames between when you can first register
  // a press for the beat and when it hits its maximum value.  The UI should
  // indicate the beat happening this many frames after its internal start.
  // TODO(dscotton): For now this is a constant but we may want to experiment
  // with other options like frames/2.
  int get preview_frames => 10;

  Beat(this.button, this.frames) : score = null;

  /**
   * Calculate a score for this beat given the frame in which it was hit.
   */
  void scoreBeat(int frame) {

  }
}


/**
 * A combo collects numbers from completed beats and can calculate final score.
 *
 * TODO(dscotton): Procedurally generated combo names (based on effectiveness
 * and ingredients, with some hard coded combos).
 */
class Combo {
  Boss enemy;
  Set<Ingredient> ingredients;
  double multiplier;
  int baseDamage;

  Combo(this.enemy) : ingredients = new Set(), multiplier = 1.0, baseDamage = 0;

  List<Element> getElements() {
    List<Element> elements = new List();
    for (Ingredient i in ingredients) {
      elements.add(i.element);
    }
  }

  double getScore() {
    double elementMultiplier = 1.0;
    for (Element e in getElements()) {
      elementMultiplier *= enemy.getMultiplier(e);
    }
    return baseDamage * multiplier * elementMultiplier;
  }
}