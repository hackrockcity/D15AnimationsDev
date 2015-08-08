import moonpaper.*;
import moonpaper.opcodes.*;

Moonpaper moonpaper;

void setup() {
  size(500, 500, P2D);
  moonpaper = new Moonpaper(this);  
  Cel cel1 = moonpaper.createCel();
  Cel cel2 = moonpaper.createCel();
  cel1.setActive(false);
  float s1 = 55;
  float s2 = 110;

  Bouncy b1 = new Bouncy(new PVector(width / 2, height / 2), PVector.random2D(), new Patchable<Float>(s1));
  Bouncy b2 = new Bouncy(new PVector(width / 2, height / 2), PVector.random2D(), new Patchable<Float>(s2));
  b1.c = color(255, 255, 0);
  b2.c = color(0, 255, 255);

  int nFrames = 60;
  int lineDur = 30;
  moonpaper.seq(new ClearCels());
  moonpaper.seq(new PushCel(cel1, b1));
  moonpaper.seq(new PushCel(cel2, b2));  
  moonpaper.seq(new Line(lineDur, b1.radius, s2));
  moonpaper.seq(new Line(60, b2.radius, s1));
  moonpaper.seq(new Wait(nFrames));
  moonpaper.seq(new FlipActive());
  moonpaper.seq(new Wait(nFrames));
  moonpaper.seq(new PushCel(cel1, new Mirror()));  
  moonpaper.seq(new PushCel(cel2, new Mirror()));  
  moonpaper.seq(new Line(lineDur / 2, b1.radius, s1));
  moonpaper.seq(new Line(60, b2.radius, s2));
  moonpaper.seq(new Wait(nFrames));
  moonpaper.seq(new FlipActive());
  moonpaper.seq(new Wait(nFrames));
}

void draw() {
  background(0);
  moonpaper.update();
  moonpaper.display();
}

