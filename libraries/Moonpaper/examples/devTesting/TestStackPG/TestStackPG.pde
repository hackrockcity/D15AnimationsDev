import moonpaper.*;

StackPGraphics stackPG = new StackPGraphics(this);

void setup() {
  size(500, 500, P2D);
  smooth();
  noLoop();
  background(0);
}

void draw() {
  PGraphics pg = stackPG.push(100, 100, P2D);
    stroke(255);
  line(0, 0, width, height);
  stackPG.pop();  
  image(pg, 0, 0);
  
  PGraphics pg2 = stackPG.pushCopy(pg);
  stroke(255, 0, 255);
  line(width, 0, 0, height);
  stackPG.pop();
  image(pg2, 250, 250);
}
