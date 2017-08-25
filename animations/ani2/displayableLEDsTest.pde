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
