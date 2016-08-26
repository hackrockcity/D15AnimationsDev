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
 * CrossyAnimation 1D Animation
 *
 * Target the sign.ledList. Using Helios Pattern with Gradient
 */
class CrossyAnimation extends DisplayableLEDs {
  Sign sign;
  color c0 = orange;
  color c1 = pink;
  ArrayList<Boolean> heliosPattern = new ArrayList<Boolean>();
  Patchable<Float> heliosOdds = new Patchable<Float>(0.01);
  Patchable<Boolean> isGenerating = new Patchable<Boolean>(true);


  CrossyAnimation(PixelMap pixelMap, SignStructure structure) {
    super(pixelMap, structure);
    SignStructure signStructure = (SignStructure) structure;
    this.sign = signStructure.sign;

    for (int i = 0; i < sign.ledList.size() - 1; i++) {
      //heliosPattern.add(random(1.0) < heliosOdds.value());
      heliosPattern.add(false);
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

    if (isGenerating.value()) {
      heliosPattern.add(0, random(1.0) < heliosOdds.value());
    } else {
      heliosPattern.add(0, false);
    }

    if (heliosPattern.size() == sign.ledList.size()) {
      heliosPattern.remove(sign.ledList.size() - 1);
    }

    // Copy Sign LEDs to PixelMap
    copyLEDList(sign.ledList);
    super.update();
  }
}

/**
 * CrossyAnimation 1D Animation
 *
 * Target the sign.ledSegmentsList. Black Fade to Bright Gradient Scroller 
 */
class LetterSegmentScroller extends DisplayableLEDs {
  Sign sign;
  int nSegments = 24;
  int frame = 0;

  LetterSegmentScroller(PixelMap pixelMap, SignStructure structure) {
    super(pixelMap, structure);
    SignStructure signStructure = (SignStructure) structure;
    this.sign = signStructure.sign;
  }

  void update() {
    clear();
    sign.clear();

    int size = sign.ledSegmentsList.size();
    int segmentIndex = frame % size;
    frame++;

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

class FlickerSegment extends DisplayableLEDs {
  Sign sign;
  int index = 0;
  float n = 0.0;
  float nInc = 0.1;
  float min = 0.5;
  float max = 1.0;

  FlickerSegment(PixelMap pixelMap, SignStructure structure) {
    super(pixelMap, structure);
    SignStructure signStructure = (SignStructure) structure;
    this.sign = signStructure.sign;
  }

  void update() {
    float brightness = random(min, max);
    LEDList ledList = sign.ledSegmentsList.get(index);
    for (LED led : ledList) {
      color c = led.c;
      led.c = color(red(c) * brightness, green(c) * brightness, blue(c) * brightness);
    }
    copyLEDList(sign.ledList);
    super.update();
  }
}

class FlickerLetter extends DisplayableLEDs {
  Sign sign;
  Patchable<Integer> index = new Patchable<Integer>(0);
  float n = 0.0;
  float nInc = 0.1;
  float min = 0.5;
  float max = 1.0;

  FlickerLetter(PixelMap pixelMap, SignStructure structure) {
    super(pixelMap, structure);
    SignStructure signStructure = (SignStructure) structure;
    this.sign = signStructure.sign;
  }

  void update() {
    float brightness = random(min, max);
    LEDList ledList = sign.letterList.get(index.value()).ledList;
    for (LED led : ledList) {
      color c = led.c;
      led.c = color(red(c) * brightness, green(c) * brightness, blue(c) * brightness);
    }
    copyLEDList(sign.ledList);
    super.update();
  }
}

class SparkleSegment extends DisplayableLEDs {
  Sign sign;
  float odds = 0.002;
  float decayAmount = 0.04;
  color c = white;
  
  SparkleSegment(PixelMap pixelMap, SignStructure structure) {
    super(pixelMap, structure);
    SignStructure signStructure = (SignStructure) structure;
    this.sign = signStructure.sign;
  }

  void update() {
    for (LEDList segment : sign.ledSegmentsList) {
      if (random(1.0) < odds) {
        // Set all to color
        segment.setAll(c);
      } else {
        // Decay all LEDs here
        LED led = segment.get(0);
        color c = lerpColor(led.c, black, decayAmount);
        segment.setAll(c);
      }
    }

    copyLEDList(sign.ledList);
    super.update();
  }
}