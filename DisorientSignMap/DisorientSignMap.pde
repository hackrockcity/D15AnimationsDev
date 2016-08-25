Sign sign = new Sign();
SignTester signTester = new SignTester();
PGraphics pg;

boolean captureFrames = false;
int nFrames = 3600;
float phase = 0;
float phaseInc = 1 / float(nFrames);

ArrayList<Boolean> heliosPattern = new ArrayList<Boolean>();
float heliosOdds = 0.1;
float fade = 0.95;

void settings() {
  size(336, 29, P2D);
  //size(336 * 2, 29 * 2, P2D);
  //noLoop();
}

void setup() {
  frameRate(30);
  background(0);
  pg = createGraphics(sign.w, sign.h, P2D);
  pg.beginDraw();
  pg.background(255, 128, 0);
  pg.endDraw();


  //for (LED led : sign.ledList) {
  //  heliosPattern.add(random(1.0) < heliosOdds);
  //}

  // fill Helios pattern
  for (int i = 0; i < sign.ledList.size() - 1; i++) {
    heliosPattern.add(random(1.0) < heliosOdds);
  }
}



void draw() {
  //scale(2);
  background(0);

  color orange = color(255, 128, 0);
  color magenta = color(255, 0, 255);

  // Set pixels manually using ledList
  //int counter = 0;
  //for (LED led : sign.ledList) {
  //  float n = counter / (float) sign.ledList.size();
  //  counter++;
  //  float s = sin((phase + n) * TWO_PI * 2) * 0.5 + 0.5;
  //  color c = lerpColor(orange, magenta, s);
  //  led.set(c);
  //}

  // Set pixels manually per letter
  //for (SignLetter letter : sign.letterList) {
  //  int counter = 0;
  //  int maxCounter = letter.ledList.size();
  //  for (LED led : letter.ledList) {
  //    float n = counter / (float) maxCounter;
  //    float s = sin((phase + n) * TWO_PI) * 0.5 + 0.5;
  //    color c = lerpColor(orange, magenta, s);
  //    led.set(c);
  //    counter++;
  //  }
  //  if (counter >= maxCounter) {
  //    counter -= maxCounter;
  //  }
  //}

  // 2D Map Gradient
  //for (LED led : sign.ledList) {
  //  float n = led.position.y / (float) sign.h;
  //  float s = sin((phase + n) * TWO_PI) * 0.5 + 0.5;
  //  color c = lerpColor(orange, magenta, s);
  //  led.set(c);
  //}


  // Clear LEDs
  //sign.clear();

  // Fade
  for (LED led : sign.ledList) {
    color c = led.c;
    float a = (float) (c >> 24 & 0xff) * fade;
    float r = (float) (c >> 16 & 0xff) * fade;
    float g = (float) (c >> 8 & 0xff) * fade;
    float b = (float) (c & 0xff) * fade;
    led.c = (int) a << 24 | (int) r << 16 | (int) g << 8 | (int) b;
  }

  // White segment scroll: Target segments
  int size = sign.ledSegmentsList.size();
  int segmentIndex = frameCount % size;
  int nSegments = 24;
  for (int i = 0; i < nSegments; i++) {
    //int thisIndex = (segmentIndex + size / nSegments * i) % size;
    int thisIndex = (segmentIndex + i) % size;
    for (LED led : sign.ledSegmentsList.get(thisIndex)) {
      led.c = color(255 - i * 255 / nSegments);
      //led.c = lerpColor(color(255), lerpColor(orange, magenta, led.position.y / sign.h), i / (float) nSegments);
    }
  }

  // Helios Pattern
  int counter = 0;

  for (Boolean b : heliosPattern) {
    LED led = sign.ledList.get(counter);
    LED led2 = sign.ledList.get(sign.ledList.size() - counter - 1);
    if (b) {
      //led.c = magenta;
      //led2.c = orange;

      //led.c = color(255);
      //led2.c = color(255);

      led.c = lerpColor(orange, magenta, led.position.y / sign.h);
      led2.c = lerpColor(orange, magenta, led2.position.y / sign.h);
    }
    counter++;
  }

  heliosPattern.add(0, random(1.0) < heliosOdds);
  if (heliosPattern.size() == sign.ledList.size()) {
    heliosPattern.remove(sign.ledList.size() - 1);
  }

  // Random sparkle
  //int nSparkles = 10;
  //for (int i = 0; i < nSparkles; i++) {
  //  LED led = sign.ledList.get((int) random(sign.ledList.size()));
  //  if (led.c != 0) {
  //    led.c = color(255);
  //  }
  //}


  //sign.set(pg);
  sign.display();


  //signTester.update();

  phase += phaseInc;
  if (phase >= 1.0) {
    phase -= 1.0;
  }

  if (captureFrames) {
    saveFrame("./png/f######.png");
    if (frameCount >= nFrames) {
      exit();
    }
  }
}

void keyPressed() {
  redraw();
}