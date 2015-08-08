import moonpaper.*;

StackPGraphics stackPG = new StackPGraphics(this);

void setup() {
  size(200, 200, P2D);
  smooth();
  noLoop();
}

void draw() {
  background(0);
  fill(255);
  rect(50, 50, 100, 100);
  stackPG.pushCopy();
  filter(BLUR, 20);
  stackPG.pop(ADD);
}
