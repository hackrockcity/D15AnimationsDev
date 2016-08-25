/**
 * SignAnimationTest 1D Animation
 *
 * Moves a single pixel across the screen.
 */
class SignAnimationTest extends DisplayableLEDs {
  color c = magenta;
  int index = 0;  

  SignAnimationTest(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
  }

  void update() {
    clear();
    leds.get(index).c = color(c);
    index = (index + 1) % leds.size();
    super.update();
  }
}

/**
 * SignAnimationTest2 1D Animation
 *
 * Target the sign.ledList
 */
class SignAnimationTest2 extends DisplayableLEDs {
  Sign sign;
  float phase = 0.0;
  float phaseInc = 0.01;

  SignAnimationTest2(PixelMap pixelMap, SignStructure structure) {
    super(pixelMap, structure);
    SignStructure signStructure = (SignStructure) structure;
    this.sign = signStructure.sign;
  }

  void update() {
    clear();
    sign.clear();

    // Set pixels manually using ledList
    int counter = 0;
    for (LED led : sign.ledList) {
      float n = counter / (float) sign.ledList.size();
      counter++;
      float s = sin((phase + n) * TWO_PI * 2) * 0.5 + 0.5;
      color c = lerpColor(orange, magenta, s);
      led.set(color(c));
    }

    // Update phase
    phase += phaseInc;
    if (phase >= 1.0) {
      phase -= 1.0;
    }

    // Copy Sign LEDs to PixelMap
    copyLEDList(sign.ledList);
    super.update();
  }
}

/**
 * SignAnimationTest3 1D Animation
 *
 * Target the sign.ledList. Using Helios Pattern with Gradient
 */
class SignAnimationTest3 extends DisplayableLEDs {
  Sign sign;
  color c0 = color(255, 128, 0);
  color c1 = color(255, 0, 255);
  ArrayList<Boolean> heliosPattern = new ArrayList<Boolean>();
  float heliosOdds = 0.1;


  SignAnimationTest3(PixelMap pixelMap, SignStructure structure) {
    super(pixelMap, structure);
    SignStructure signStructure = (SignStructure) structure;
    this.sign = signStructure.sign;

    for (int i = 0; i < sign.ledList.size() - 1; i++) {
      heliosPattern.add(random(1.0) < heliosOdds);
    }
  }

  void update() {
    sign.clear();

    // Helios Pattern
    int counter = 0;

    for (Boolean b : heliosPattern) {
      LED led = sign.ledList.get(counter);
      LED led2 = sign.ledList.get(sign.ledList.size() - counter - 1);
      if (b) {
        led.c = lerpColor(c0, c1, led.position.y / sign.h);
        led2.c = led.c;
      }
      counter++;
    }

    heliosPattern.add(0, random(1.0) < heliosOdds);
    if (heliosPattern.size() == sign.ledList.size()) {
      heliosPattern.remove(sign.ledList.size() - 1);
    }

    // Copy Sign LEDs to PixelMap
    copyLEDList(sign.ledList);
    super.update();
  }
}

/**
 * SignAnimationTest3 1D Animation
 *
 * Target the sign.ledSegmentsList. Black Fade to Bright Gradient Scroller 
 */
class SignAnimationTest4 extends DisplayableLEDs {
  Sign sign;
  int nSegments = 24;

  SignAnimationTest4(PixelMap pixelMap, SignStructure structure) {
    super(pixelMap, structure);
    SignStructure signStructure = (SignStructure) structure;
    this.sign = signStructure.sign;
  }

  void update() {
    sign.clear();

    int size = sign.ledSegmentsList.size();
    int segmentIndex = frameCount % size;
    int nSegments = 24;
    for (int i = 0; i < nSegments; i++) {
      int thisIndex = (segmentIndex + i) % size;
      for (LED led : sign.ledSegmentsList.get(thisIndex)) {
        led.c = color(255 - i * 255 / nSegments);
      }
    }
    // Copy Sign LEDs to PixelMap
    copyLEDList(sign.ledList);
    super.update();
  }
}