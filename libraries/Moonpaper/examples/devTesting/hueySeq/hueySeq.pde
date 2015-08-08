import moonpaper.*;
import moonpaper.opcodes.*;

Moonpaper mp;


class Huey extends Displayable {
  Patchable<Float> hue;
  
  Huey() {
    hue = new Patchable<Float>(0.0);
  }
  
  void update() {
  }
  
  void display() {
    pushStyle();
    colorMode(HSB);
    background(hue.value(), 255, 255);
    popStyle();
  }
}


class RandomValue extends MoonCodeEvent {
  Patchable<Float> pf;
  float low;
  float high;
  
  RandomValue(Patchable<Float> pf, float low, float high) {
    this.pf = pf;
    this.low = low;
    this.high = high;
  }
  
  void exec() {
    pf.set(random(low, high));
  }
}


void setup() {
  mp = new Moonpaper(this);
  Cel cel = mp.createCel();
  Huey h = new Huey();
  
  mp.seq(new ClearCels());
  mp.seq(new PushCel(cel, h));  
  mp.seq(new Wait(10));
  mp.seq(new RandomValue(h.hue, 0, 255));
}

void draw() {
  mp.update();
  mp.display();
}
