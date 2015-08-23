/*

 StripSweep is an example of applying an animation to each individual
 strip within a structure. In this case, it moves a pixel from the
 starting point to the end point, and then starts over again.

 Since strip lengths are different, they'll begin to appear out of
 sync after the first pass.

 The class StripAnimation is embedded as an inner class of StripSweep.
 This acts as a data structure that will track the current position
 of the pixel for each strip.

 In StripSweep.update(), the animation positions are then applied
 to the local pg.

 */

class StripSweep extends DisplayableStrips {
  ArrayList<StripAnimation> animations;

  // Used as a data structure to track the pixel position for each
  // individual strip.
  class StripAnimation {
    Strip strip;
    int position;

    StripAnimation(Strip strip) {
      this.strip = strip;
      position = 0;
    }

    void update() {
      position = (position + 1) % strip.nLights;
    }
  }

  StripSweep(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
  }

  void setup() {
   super.setup();
    
    // Create the individual animation data for each strip
    animations = new ArrayList<StripAnimation>();
    for (Strip strip : strips) {
      animations.add(new StripAnimation(strip));
    }
  }

  void update() {
    super.update();
    
    // Update each animation
    for (StripAnimation animation : animations) {
      animation.update();
    }
  }

  void display() {
    pg.beginDraw();
    pg.clear();
    pg.loadPixels();

    // Apply animations to each strip. Each row in the pg represents
    // a strip. The rows / strips are in order from which they are
    // loaded from the JSON file
    for (int row = 0; row < pg.height; row++) {
      StripAnimation animation = animations.get(row);
      pg.pixels[row * pg.width + animation.position] = color(255, 128, 0);
    }

    pg.updatePixels();
    pg.endDraw();
    super.display();
  }
}

