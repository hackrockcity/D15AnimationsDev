import moonpaper.*;

int nCircles = 3;
int circleSize = 100;
Cel cel;

void setup() {
  size(500, 500);
  cel = new Cel(this, width, height);
  
  for (int i = 0; i < nCircles; i++) {
    float angle = random(TWO_PI);
    Bouncy b = new Bouncy(new PVector(width / 2, height / 2), PVector.fromAngle(angle), circleSize);
    b.setBlendMode(DIFFERENCE);
    cel.add(b);
  }
  
  cel.add(new Mirror());
  cel.add(new Sparkle());
}

void draw() {
  background(0);
  cel.update();
  cel.display();
}
