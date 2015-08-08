class Bouncy extends Displayable {
  PVector location;
  PVector velocity;
  Patchable<Float> radius;
  color c = color(255);
  
  Bouncy(PVector l, PVector v, Patchable<Float> r) {
    location = l;
    velocity = v;
    radius = r;
  }
  
  void display() {
    fill(c);
    noStroke();
    ellipse(location.x, location.y, radius.value() * 2, radius.value() * 2);
  }
  
  void update() {
    location.add(velocity);

    float offset = radius.value();
    float boundryRight = width - 1 - offset;
    float boundryBottom = height - 1 - offset;

    if (location.x < offset) {
      location.x = offset;
      velocity.x *= -1;
    }

    if (location.x > boundryRight) {
      location.x = boundryRight;
      velocity.x *= -1;
    }

    if (location.y < offset) {
      location.y = offset;
      velocity.y *= -1;
    }

    if (location.y > boundryRight) {
      location.y = boundryRight;
      velocity.y *= -1;
    }
  }
}
