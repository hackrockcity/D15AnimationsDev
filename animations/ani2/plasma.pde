class Plasma extends DisplayableLEDs {
  Patchable<Float> nInc = new Patchable<Float>(0.01);
  float nx = 0.0;
  float ny = 1000;
  float xInc = 0.0;
  float yInc = -0.005;
  float phase = 0.0;
  float phaseInc = 0.0005;
  Gradient gradient;

  Plasma(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
    nx = random(10000);
    ny = random(10000);
    phase = random(1.0);
    createDefaultGradient();
  }

  Plasma(PixelMap pixelMap, Structure structure, Gradient gradient) {
    super(pixelMap, structure);
    this.gradient = gradient;
  }

  void createDefaultGradient() {
    gradient = new Gradient();
    float edgeThickness = 0.01;
    gradient.add(white, edgeThickness);
    gradient.add(pink, 1);
    gradient.add(color(pink, 0), edgeThickness);
    gradient.add(white, 0.1);
    gradient.add(orange, 1);
    gradient.add(color(orange, 0), edgeThickness);
    gradient.add(white, 0.1);
    gradient.add(magenta, 1);
    gradient.add(color(magenta, 0), edgeThickness);
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
