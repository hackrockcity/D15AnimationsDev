class Plasma extends DisplayableLEDs {
  color c1 = color(0);
  color c2 = color(255, 128, 0);
  Patchable<Float> nInc = new Patchable<Float>(0.01);
  float nx = 0.0;
  float ny = 0.0;
  float xInc = 0.0;
  float yInc = -0.005;
  float phase = 0.0;
  float phaseInc = 0.0005;
  Gradient gradient;

  Plasma(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
    createDefaultGradient();
  }

  Plasma(PixelMap pixelMap, Structure structure, Gradient gradient) {
    super(pixelMap, structure);
    this.gradient = gradient;
  }  

  void createDefaultGradient() {
    gradient = new Gradient();
    gradient.add(color(255, 255, 255), 0.1);
    gradient.add(color(255, 32, 180), 1);
    gradient.add(color(255, 32, 180, 0), 0.1);
    gradient.add(color(255, 255, 255), 0.1);
    gradient.add(color(255, 128, 0), 1);
    gradient.add(color(255, 128, 0, 0), 0.1);
  }

  void update() {
    for (LED led : leds) {
      float v = noise(led.position.x * nInc.value() + nx, led.position.y * nInc.value() + ny, led.position.z * nInc.value() + ny);
      v += phase;
      v *= 1;
      v -= int(v);
      led.c = gradient.getColor(v);
    }

    ny += yInc;
    nx += xInc;
    phase += phaseInc;
    phase -= int(phase);

    super.update();
  }
}