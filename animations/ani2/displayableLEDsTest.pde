class DisorientFont extends DisplayableLEDs {
  color c = white;
  int index = 0;
  boolean isSolid = true;

  DisorientFont(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
  }

  void update() {
    clear();
    int xScale = 3;
    leds.get(index).c = color(c);
    index = (index + 1) % leds.size();

    // ArrayList<PVector> pList = df.getPoints('D');
    ArrayList<PVector> pList = df.getPoints("Disorient");
    for (PVector p : pList) {
      if (isSolid) {
        int xPos = (int) p.x * xScale;
        for (int i = 0; i < xScale; i++) {
          setPixel(xPos + i, (int) p.y, c);
        }
      } else {
        setPixel((int) (p.x * xScale), (int) p.y, c);
      }
    }

    setPixel(5, 11, c);
    super.update();
  }

  private void setPixel(PVector p, color c) {
    setPixel((int) p.x, (int) p.y, c);
  }

  private void setPixel(int x, int y, color c) {
    int w = x + y * teatroWidth;
    int maxWidth = 12 * teatroWidth;
    if (w >= 0 && x < maxWidth && x >= 0 && x < teatroWidth &&
        y >= 0 && y < teatroHeight) {
      pixelMapPG.pixels[x + y * teatroWidth] = c;
    }
  }
}

class DisplayableLEDsTest extends DisplayableLEDs {
  color c = white;
  int index = 0;

  DisplayableLEDsTest(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
  }

  void update() {
    clear();
    leds.get(index).c = color(c);
    index = (index + 1) % leds.size();


    setPixel(5, 11, c);
    super.update();
  }

  private void setPixel(int x, int y, color c) {
    pixelMapPG.pixels[x + y * teatroWidth] = c;
  }
}
