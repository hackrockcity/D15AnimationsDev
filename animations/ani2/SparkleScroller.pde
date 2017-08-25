class SparkleScroller extends DisplayableLEDs {
  class Pixel {
    PVector p;
    float phase;
    float phaseInc = -0.01;
    color c = color(255);

    Pixel(PVector p) {
      this.p = p;
      phase = random(1.0);
    }

    void update() {
      c = color(phase * 256);
      phase += phaseInc + random(phaseInc);
      if (phase < 0) {
        phase += 1;
      } else if (phase >= 1.0) {
        phase -=1;
      }
    }
  }

  color c = orange;
  boolean isSolid = true;
  int xOffset = 0;
  int yOffset = 2;
  int speed = -1;
  int xScale = 4;
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
      pixel.update();
    }
  }

  void setText(String s) {
    text = s;
    pList = new ArrayList<Pixel>(); // Reset pList

    // Create pixels from font
    ArrayList<PVector> points = df.getPoints(text);
    println(points);
    for (PVector p : points) {
      for (int i = 0; i < xScale; i++) {
        PVector pTemp = p.copy();
        pTemp.x *= xScale;
        pTemp.x += i;
        pList.add(new Pixel(pTemp));
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
