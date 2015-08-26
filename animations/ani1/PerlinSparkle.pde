class PerlinSparkle extends DisplayableLEDs {
  color c1 = color(0);
  color c2 = color(255, 128, 0);
  float nInc = 0.01;
  float nx = 0.0;
  float ny = 0.0;
  float xInc = 0.0;
  float yInc = -0.005;
  float phase = 0.0;
  float phaseInc = 0.0005;
  Gradient gradient;

  float odds = 0.005;
  float decay = 3;
  LEDs sparkleLeds;
  
  
  PerlinSparkle(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
    createDefaultGradient();
  }
  
  PerlinSparkle(PixelMap pixelMap, Structure structure, Gradient gradient) {
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
        int counter = 0;
    
    
        
    for (LED led : leds) {
      float v = noise(led.position.x * nInc + nx, led.position.y * nInc + ny, led.position.z * nInc + ny);
      v += phase;
      v *= 1;
      v -= int(v);


      // SparklePart
      color c = led.c;
      c = color(
      (c >> 16 & 0xff) - decay, 
      (c >> 8 & 0xff) - decay, 
      (c & 0xff) - decay, 
      (c >> 24 & 0xff) - decay);
      
      led.c = c;

      if (random(1.0) < odds && v < 0.0001) {
        led.c = gradient.getColor(v);
      }
    }



    ny += yInc;
    nx += xInc;
    phase += phaseInc;
    phase -= int(phase);

    super.update();
  }
}

