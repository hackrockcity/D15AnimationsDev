public class Gradient {
  private Points points;
  private float n;

  public class Points extends ArrayList<Point> {
  }

  public class Point {
    public color col;
    public float len;

    public Point() {
    }

    public Point(color col, float len) {
      this.col = col;
      this.len = len;
    }
  }

  public Gradient() {
    points = new Points();
  }

  public void add(color col, float len) {
    points.add(new Point(col, len));
    n += len;
  }

  public color getColor(float interp) {
    int s = points.size();
    interp *= n;
    
    if (s == 0) {
      return 0;
    } else if (s == 1) {
      return points.get(0).col;
    } else {
      Point p1 = new Point();
      Point p2 = new Point();
      float counter = 0;
      float counterNext = 0;

      for (int i = 0; i < s; i++) {
        p1 = points.get(i);
        p2 = points.get((i + 1) % s);
        counter = counterNext;
        counterNext += p1.len;
        
        if (interp < counterNext) {
          break;
        }
      }

      return lerpColor(p1.col, p2.col, map(interp, counter, counterNext, 0.0, 1.0));
    }
  }
}


class Plasma extends DisplayableLEDs {
  color c1 = color(0);
  color c2 = color(255, 128, 0);
  float nInc = 0.01;
  float nx = 0.0;
  float ny = 0.0;
  float xInc = 0.0;
  float yInc = 0.001;
  float phase = 0.0;
  float phaseInc = 0.001;
  Gradient gradient;
  
  Plasma(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
    gradient = new Gradient();
    gradient.add(color(255, 255, 255), 0.1);
    gradient.add(color(255, 32, 180), 1);
    gradient.add(color(255, 32, 180, 0), 0.1);
    gradient.add(color(255, 255, 255), 0.1);
    gradient.add(color(255, 128, 0), 1);
    gradient.add(color(255, 128, 0, 0), 0.1);
  }

  void update() {
    for (LED led : leds) {
      float v = noise(led.position.x * nInc + nx, led.position.y * nInc + ny, led.position.z * nInc + ny);
      v += phase;
      v *= 1;
      v -= int(v);
      led.c = gradient.getColor(v);
    }

    ny += yInc;
    nx += xInc;
    phase += phaseInc;
    phase -= int(phase);

    super.update();
  }
}

