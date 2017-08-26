class SparkleScroller extends DisplayableLEDs {
  class Pixel {
    PVector p;
    float phase;
    float phaseInc = 0.03;
    color baseColor = orange;
    color c = baseColor;

    Pixel(PVector p) {
      this.p = p;
      phase = random(1.0);
    }

    void update() {
      // c = color(phase * brightness.value() * 256.0);
      if (random(1.0) < 0.05) {
        c = lerpColor(black, white, phase * brightness.value());
      } else {
        c = lerpColor(black, magenta, phase * brightness.value());
      }
      //c = lerpColor(magenta, black, 0.27);
      phase += phaseInc + random(phaseInc);
      if (phase < 0) {
        phase += 1;
      } else if (phase >= 1.0) {
        phase -=1;
      }
    }
  }

  Patchable<Float> brightness = new Patchable<Float>(1.0);
  int xOffset = 0;
  int yOffset = 0;
  int speed = -2;
  int xScale = 3;
  String text = "hello world";
  private ArrayList<Pixel> pList = new ArrayList<Pixel>();
  int textWidth;

  SparkleScroller(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
  }

  void init() {
    setText(text);
  }

  void update() {
    clear();
    updatePixels();

    for (Pixel pixel : pList) {
      PVector p = pixel.p;
      setPixel((int) (p.x), (int) p.y, pixel.c);
    }

    xOffset += speed;
    if (xOffset > textWidth || xOffset < -textWidth) {
      xOffset = 0;
    }

    super.update();
  }

  void updatePixels() {
    for (Pixel pixel : pList) {
      float x = pixel.p.x + xOffset;
      float y = pixel.p.y + yOffset;
      if (x >= 0 && x < teatroWidth && y >= 0 && y < teatroHeight) {
        pixel.update();
      }
    }
  }

  void setText(String s) {
    text = s;
    pList = new ArrayList<Pixel>(); // Reset pList

    // Create pixels from font
    ArrayList<PVector> points = df.getPoints(text);
    for (PVector p : points) {
      for (int i = 0; i < xScale; i++) {
        PVector pTemp = p.copy();
        pTemp.x *= xScale;
        pTemp.x += i;
        Pixel pixel = new Pixel(pTemp);
        pList.add(pixel);
      }
    }

    // start text to the right
    for (Pixel pixel : pList) {
      pixel.p.x += teatroWidth;
    }

    // Get farthest x point
    int lastX = 0;
    for (Pixel pixel : pList) {
      if (pixel.p.x > lastX) {
        lastX = (int) pixel.p.x;
      }
    }

    textWidth = lastX;
    println(textWidth);
  }

  private void setPixel(int x, int y, color c) {
    x += xOffset;
    y += yOffset;
    int w = x + y * teatroWidth;
    int maxWidth = 12 * teatroWidth;
    if (w >= 0 && x < maxWidth && x >= 0 && x < teatroWidth &&
      y >= 0 && y < teatroHeight) {
      pixelMapPG.pixels[x + y * teatroWidth] = c;
    }
  }
}