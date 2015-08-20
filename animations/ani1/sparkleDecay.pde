

class SparkleDecay extends DisplayableLEDs {
  color c1 = color(128);
  float odds = 0.001;
  float decay = 4;

  SparkleDecay(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
  }

  void setup() {
    super.setup();
    clear();
    theBlendMode.set(ADD);
  }

  void update() {
    int counter = 0;

    for (LED led : leds) {
      color c = led.c;
      c = color(
      (c >> 16 & 0xff) - decay, 
      (c >> 8 & 0xff) - decay, 
      (c & 0xff) - decay, 
      (c >> 24 & 0xff) - decay);
      
      led.c = c;

      if (random(1.0) < odds) {
        led.c = c1;
      }
    }

    super.update();
  }
}

