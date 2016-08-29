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

class SparkleSegmentAll extends DisplayableLEDs {
  float odds = 0.002;
  float decayAmount = 0.04;
  color c = white;
  int maxLength = 30;
  int minLength = 4;
  LEDList tempList = new LEDList();

  SparkleSegmentAll(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);

    for (int i = 0; i < leds.size(); i++) {
      tempList.add(new LED());
    }
  }

  void update() {
    //clear();

    int startIndex = (int) random(0, leds.size());
    int endIndex = startIndex + (int) random(minLength, maxLength);
    endIndex = min(endIndex, leds.size());

    for (int i = 0; i < tempList.size(); i++) {
      LED led = tempList.get(i);
      color c = lerpColor(led.c, black, decayAmount);
      led.c = c;
    }

    if (random(1.0) < 0.5) {
      for (int i = startIndex; i < endIndex; i++) {
        tempList.get(i).c = white;
      }
    }

    for (int i = 0; i < tempList.size(); i++) {
      leds.get(i).c = tempList.get(i).c;
    }
    super.update();
  }
}


class RGB extends DisplayableLEDs {
  Sign sign;
  int nFrames = 10;
  int framesLeft = nFrames;
  ArrayList<Integer> ticks = new ArrayList<Integer>();
  int currentLetter = 0;
  color[] colors = {color(255, 0, 0), color(0, 255, 0), color(0, 0, 255)}; 

  RGB(PixelMap pixelMap, SignStructure structure) {
    super(pixelMap, structure);
    SignStructure signStructure = (SignStructure) structure;
    this.sign = signStructure.sign;

    for (int i = 0; i < sign.letterList.size(); i++) {
      ticks.add(0);
    }
  }

  void update() {
    for (int i = 0; i < ticks.size(); i++) {
      SignLetter letter = sign.letterList.get(i);
      letter.ledList.setAll(colors[ticks.get(i)]);
    }

    if (--framesLeft == 0) {
      framesLeft = nFrames;

      color v = ticks.get(currentLetter);
      v = (v + 1) % colors.length;
      ticks.set(currentLetter, v);

      currentLetter = (currentLetter + 1) % ticks.size();
    }


    copyLEDList(sign.ledList);
    super.update();
  }
}

class SignTester extends DisplayableLEDs {
  Sign sign;

  SignTester(PixelMap pixelMap, SignStructure structure) {
    super(pixelMap, structure);
    SignStructure signStructure = (SignStructure) structure;
    this.sign = signStructure.sign;
  }

  void update() {
    clear();
    sign.clear();

    // Colorize
    for (SignLetter letter : sign.letterList) {
      for (LEDSegmentsList segments : letter.channelSegmentsList) {
        int nSegments = segments.size();
        pushStyle();
        colorMode(HSB);
        for (int i = 0; i < nSegments; i++) {
          LEDList segment = segments.get(i);
          segment.setAll(color(i / (float) nSegments * 256, 255, 255));
        }
        popStyle();
      }
    }

    copyLEDList(sign.ledList);
    super.update();
  }
}

class ShootingStars extends DisplayableLEDs {
  color c = orange;
  int index = 0;
  int nStarsPerFrame = 20;
  int nFrames = 60;
  StarList starList = new StarList();

  class StarList extends ArrayList<Star> {
  }

  class Star {
    int position;
    int direction;
    color c;
    int framesLeft = fps;
    int nFrames;

    Star(int position, color c, int nFrames, int direction) {
      this.position = position;
      this.c = c;
      this.direction = direction;
      this.nFrames = nFrames;
      framesLeft = this.nFrames;
    }

    void update() {

      leds.get(position).c = lerpColor(white, color(0, 0), (float) framesLeft / (float) nFrames);
      position += direction;
      position %= leds.size();
      if (position < 0) {
        position += leds.size();
      }
      framesLeft--;
    }
  }

  ShootingStars(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
  }

  void update() {
    clear();

    for (int i = 0; i < nStarsPerFrame; i++) {
      int position = (int) random(leds.size());
      int direction = random(1.0) < 0.5 ? 1 : -1;
      Star star = new Star(position, c, nFrames, direction * (int) random(1, 2));
      starList.add(star);
    }

    for (Star star : starList) {
      star.update();
    }

    Iterator iter = starList.iterator(); 
    while (iter.hasNext()) {
      Star star = (Star) iter.next();
      star.update();
      if (star.framesLeft == 0) {
        iter.remove();
      }
    }

    super.update();
  }
}