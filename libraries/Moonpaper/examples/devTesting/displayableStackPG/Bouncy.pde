class Bouncy extends Displayable {
  PVector location;
  PVector velocity;
  float radius;
  
  void init() {
    location.x = width / 2;
    location.y = height / 2;
  }
  
  Bouncy(PVector l, PVector v, float r) {
    location = l;
    velocity = v;
    radius = r;
  }
  
  void display() {
    fill(180, 0, 0);
    noStroke();
    ellipse(location.x, location.y, radius * 2, radius * 2);
  }
  
  void update() {
    location.add(velocity);

    float offset = radius;
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
