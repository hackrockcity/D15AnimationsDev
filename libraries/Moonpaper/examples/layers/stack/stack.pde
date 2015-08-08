import moonpaper.*;

StackPGraphics stackpg;

void drawSomeRectangles() {
  colorMode(HSB);
  noStroke();
  blendMode(ADD);
  for (int i = 0; i < 100; i++) {
    fill(random(255), 255, 255, 48);
    rect(random(width), random(height), random(50, 100), random(50, 100));
  }
}

void setup() {
  size(500, 500);
  noLoop();
  stackpg = new StackPGraphics(this);

  background(0);         // Layer 0
  stackpg.push();        // New Layer 1
  drawSomeRectangles();  // Draws to Layer 1
  stackpg.pushCopy();    // Copy Layer 1 to new Layer 2
  filter(BLUR, 10);      // Blur Layer 2
  stackpg.pop(ADD);      // Additive Blend Layer 2 onto Layer 1
  stackpg.pop(BLEND);    // Normal Blend Layer 1 onto Layer 0
}

