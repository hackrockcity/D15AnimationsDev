class Scroller extends DisplayableLEDs {
  color c = orange;
  boolean isSolid = true;
  int xOffset = 0;
  int yOffset = 2;
  int speed = -1;
  int xScale = 3;
  String text = "hello world";
  private ArrayList<PVector> pList;
  int textWidth;

  Scroller(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
  }

  void init() {
    setText(text);
  }

  void update() {
    clear();

    for (PVector p : pList) {
      if (isSolid) {
        int xPos = (int) p.x;
        for (int i = 0; i < xScale; i++) {
          setPixel(xPos + i, (int) p.y, c);
        }
      } else {
        setPixel((int) (p.x), (int) p.y, c);
      }
    }

    xOffset += speed;
    if (xOffset > textWidth || xOffset < -textWidth) {
      xOffset = 0;
    }

    super.update();
  }

  void setText(String s) {
    text = s;
    pList = df.getPoints(text);

    int lastX = 0;

    // Move positions
    for (PVector p : pList) {
      p.x *= xScale;
    }

    // start text to the right
    for (PVector p : pList) {
      p.x += teatroWidth;
    }

    // Get farthest x point
    for (PVector p : pList) {
      if (p.x > lastX) {
        lastX = (int) p.x;
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