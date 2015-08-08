import moonpaper.*;

StackPGraphics spg;
PGraphics pgWide;
int offset = 0;
int velocity = 4;

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

void generateBackground() {
  pgWide = spg.push(1500, 500);
  drawSomeCircles(200, 50);
  PGraphics pgBlur = spg.pushCopy();
  filter(BLUR, 10);
  spg.pop();
  image(pgBlur, 0, 0);
  image(pgBlur, 0, 0);
  spg.pop();
}

void setup() {
  size(500, 500, P2D);
  spg = new StackPGraphics(this);
  generateBackground();
}

void draw() {
  background(0);
  copy(pgWide, offset, 0, width, height, 0, 0, width, height);
  offset += velocity;
  
  if (offset > pgWide.width - width - 1) {
    offset = pgWide.width - width - 1;
    velocity *= -1;
  }
  
  if (offset < 0) {
    offset = 0;
    velocity *= -1;
  }
}

