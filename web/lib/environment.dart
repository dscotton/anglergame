/**
 * Environment object handles loading and drawing the environment.
 */

part of angler_game;

class Environment {
  // Tile layers. Foreground goes on top of characters, background and middle ground go below.
  static const String LAYER_BACKGROUND = 'back';
  static const String LAYER_MIDDLEGROUND = 'mid';
  static const String LAYER_FOREGROUND = 'front';
  
  AssetManager assetManager;

  Environment(this.assetManager) {
    // TODO: load the map_data.json asset
  }
  
  /**
   * Draw the appropriate tile layer of the current environment on the canvas.
   */
  drawLayer(CanvasRenderingContext2D ctx, String layer) {
    // TODO: Write this. We need to know the current window position in the environment
    // (because the env is larger than the window), and that should be updated based on the
    // character's location.  Then we need to figure out which tiles are in window, load
    // the appropriate assets for those tiles, and draw them at the correct locations.
  }
  
  drawBackground(CanvasRenderingContext2D ctx) {
    drawLayer(ctx, LAYER_BACKGROUND);
  }
  
  drawMidground(CanvasRenderingContext2D ctx) {
    drawLayer(ctx, LAYER_MIDDLEGROUND);
  }
  
  drawForeground(CanvasRenderingContext2D ctx) {
    drawLayer(ctx, LAYER_FOREGROUND);
  }
}