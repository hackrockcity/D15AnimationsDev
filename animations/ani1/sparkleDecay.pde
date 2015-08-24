

class SparkleDecay extends DisplayableLEDs {
  color c1 = color(255);
  float odds = 0.005;
  float decay = 3;

  SparkleDecay(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
  }

  void setup() {
    super.setup();
    clear();
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

