
class Plasma extends DisplayableLEDs {
  color c1 = color(255, 80, 180);
  color c2 = color(255, 128, 0);
  float nInc = 0.01;
  float nx = 0.0;
  float ny = 0.0;
  float xInc = 0.05;
  float yInc = 0.025;
  float phase = 0.0;
  float phaseInc = 0.01;

  Plasma(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
  }

  void update() {
    for (LED led : leds) {
      float v = noise(led.position.x * nInc + nx, led.position.y * nInc + ny);
      v += phase;
      v *= 2;
      v -= int(v);
      color c = lerpColor(c1, c2, v);
      led.c = c;
    }
    
    ny += yInc;
    phase += phaseInc;
    phase -= int(phase);

    // Always call super.update() last. The super will automagically map the LED to
    // the correct position on the pixelMap
    super.update();
  }
}

