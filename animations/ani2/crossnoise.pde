import java.util.Arrays;

class CrossNoise extends DisplayableStrips {
  ArrayList<CrossNoiseAnimation> animations;
  Patchable<Float> odds;
  Patchable<Integer> theColor = new Patchable<Integer>(color(255));

  class CrossNoiseAnimation {
    Strip strip;
    ArrayList<Boolean> lights1;
    ArrayList<Boolean> lights2;
    int theLength;
    PGraphics pg;
    CrossNoise parent;

    CrossNoiseAnimation(CrossNoise parent, Strip strip) {
      this.parent = parent;
      this.strip = strip;

      theLength = strip.nLights;
      pg = createGraphics(theLength, 1);
      lights1 = new ArrayList<Boolean>();
      lights2 = new ArrayList<Boolean>();
      float odds = parent.odds.value();

      for (int i = 0; i < theLength; i++) {
        if (random(1.0) < odds) {
          lights1.add(i, true);
        } else {
          lights1.add(i, false);
        }

        if (random(1.0) < odds) {
          lights2.add(i, true);
        } else {
          lights2.add(i, false);
        }
      }
    }

    void update() {
      Boolean temp = lights1.remove(theLength - 1);
      lights1.add(0, temp);
      Boolean temp2 = lights2.remove(0);
      lights2.add(temp2);

      pg.beginDraw();
      pg.loadPixels();
      Arrays.fill(pg.pixels, color(0, 0));

      for (int i = 0; i < theLength; i++) {
        Boolean b1 = lights1.get(i);
        Boolean b2 = lights2.get(i);

        if (b1 || b2) {
          pg.pixels[i] = color(theColor.value());
        }
      }

      pg.updatePixels();
      pg.endDraw();
    }
  }

  CrossNoise(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
  }

  void setup() {
    super.setup();
    odds = new Patchable<Float>(0.06125);
    animations = new ArrayList<CrossNoiseAnimation>();

    for (Strip strip : pixelMap.strips) {
      animations.add(new CrossNoiseAnimation(this, strip));
    }
  }

  void update() {
    for (CrossNoiseAnimation a : animations) {
      a.update();
    }
  }

  void display() {
    int rows = pixelMap.rows;

    pg.beginDraw();
    pg.clear();

    for (int row = 0; row < rows; row++) {
      CrossNoiseAnimation a = animations.get(row);
      pg.image(a.pg, 0, row);
    }

    pg.endDraw();

    super.display();
  }
}