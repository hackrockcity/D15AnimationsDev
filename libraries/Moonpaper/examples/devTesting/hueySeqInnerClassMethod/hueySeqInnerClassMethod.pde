import moonpaper.*;
import moonpaper.opcodes.*;

Moonpaper mp;


class Huey extends Displayable {
  Patchable<Float> hue;

  class RandomValue extends MoonCodeEvent {
    float low;
    float high;

    RandomValue(float low, float high) {
      this.low = low;
      this.high = high;
    }

    void exec() {
      hue.set(random(low, high));
    }
  }

  Huey() {
    hue = new Patchable<Float>(0.0);
  }

  void display() {
    pushStyle();
    colorMode(HSB);
    background(hue.value(), 255, 255);
    popStyle();
  }
  
  MoonCodeEvent randomValue(float low, float high) {    
    return new RandomValue(low, high);
  }
}


void setup() {
  size(200, 200, P2D);
  mp = new Moonpaper(this);
  Cel cel = mp.createCel();
  Huey h = new Huey();

  mp.seq(new ClearCels());
  mp.seq(new PushCel(cel, h));  
  mp.seq(new Wait(10));
  mp.seq(h.randomValue(0, 255));
}

void draw() {
  mp.update();
  mp.display();
}

