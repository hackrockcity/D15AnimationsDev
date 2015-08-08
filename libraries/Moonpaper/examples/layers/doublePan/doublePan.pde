import moonpaper.*;

StackPGraphics spg;
PGraphics pgFar;
PGraphics pgClose;
float phasor = 0.0;
float increment = 0.005;

void drawSomeCircles(int nCircles, float size) {
  colorMode(HSB);
  rectMode(CENTER);
  blendMode(ADD);
  noStroke();
  for (int i = 0; i < nCircles; i++) {
    fill(random(32), 255, 255, 48);
    ellipse(random(width), random(height), size, size);
  }
}

void blurGlow(float blurAmt, int nBlends) {
  blendMode(ADD);
  PGraphics pgBlur = spg.pushCopy();
  filter(BLUR, blurAmt);
  spg.pop();
  blendMode(ADD);
  for (int i = 0; i < nBlends; i++) {
    image(pgBlur, 0, 0);
  }
  blendMode(ADD);
}

void setup() {
  size(500, 500, P2D);
  spg = new StackPGraphics(this);
  pgFar = spg.push(1000, 500);
  drawSomeCircles(200, 50);
  blurGlow(10, 2);
  spg.pop();
  pgClose = spg.push(1500, 500);
  drawSomeCircles(100, 100);
  blurGlow(5, 1);
  spg.pop();
}

void draw() {
  float sine = map(sin(phasor * TWO_PI), -1, 1, 0, 1);
  int farOffset = (int) map(sine, 0, 1, 0, pgFar.width - width);
  int closeOffset = (int) map(sine, 0, 1, 0, pgClose.width - width);
  
  background(0);
  copy(pgFar, farOffset, 0, width, height, 0, 0, width, height);
  copy(pgClose, closeOffset, 0, width, height, 0, 0, width, height);

  phasor += increment;
  if (phasor >= 1) {
    phasor -= 1;
  }
}

