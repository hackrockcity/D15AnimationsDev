import moonpaper.*;

StackPGraphics spg;

void drawSomeSquares(int nCircles, float size) {
  fill(255);
  noStroke();
  rectMode(CENTER);
  for (int i = 0; i < nCircles; i++) {
    rect(random(width), random(height), size, size);
  } 
}

void setup() {
  size(500, 500);
  noLoop();
  spg = new StackPGraphics(this);
}

void draw() {
  background(0);  
  spg.push();
  for (int i = 0; i < 6; i++) {
    spg.push();
    background(0);
    drawSomeSquares(50, 40);
    spg.pop(DIFFERENCE);
  }
  spg.pop(BLEND);
}

