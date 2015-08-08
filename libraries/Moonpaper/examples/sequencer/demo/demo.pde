import moonpaper.*;
import moonpaper.opcodes.*;

Moonpaper mp;
StackPGraphics stackpg;
PGraphics img;

void setup() {
  size(200, 200);
  mp = new Moonpaper(this);
  stackpg = new StackPGraphics(this);  
  Cel cel0 = mp.createCel();
  Cel cel1 = mp.createCel();
  cel1.setActive(false);
  cel1.setTransparency(0.0);
  
  colorMode(HSB);
  
  mp.seq(new ConsoleWrite("Start of Sequencer Loop"));  // Write message to console at beginning of sequencer loop using custom opcode
  mp.seq(new ClearCels());                              // Clear all cels off all layers
  mp.seq(new PushCel(cel0, new SetBackground()));       // Push black background to cel0
  mp.seq(new PushCel(cel1, new SetBackground()));       // Push black background to cel1
  
  // Pre-render 4 large dots and add them to cel0
  int nDots = 4;
  for (int i = 0; i < nDots; i++) {
    color c = color(map(i, 0, nDots, 0, 255), 255, 255);
    PImage dot = makeDot(200, 7, c);
    PVector startLocation = new PVector(width / 2, height / 2);
    PVector velocity = PVector.mult(PVector.fromAngle(map(i, 0, nDots, 0, TWO_PI) + QUARTER_PI), i + 4);
    MovingImage m = new MovingImage(dot, startLocation, velocity);
    m.setBlendMode(SCREEN);
    
    mp.seq(new PushCel(cel0, m));  // Add this dot as new layer to cel0
  }
  
  mp.seq(new Wait(250));                    // Wait for 250 frames
  mp.seq(new FadeOut(120, cel0));           // FadeOut cel0 over 120 frames
  mp.seq(new PushCel(cel0, new Mirror()));  // Push Mirror filter to cel0. Everything below Mirror will be mirrored.
  mp.seq(new FadeIn(120, cel0));            // Fade back in cel 0.
  mp.seq(new Wait(250));                    // Wait

  // Pre-render 8 small dots and add them to cel1
  nDots = 8;
  for (int i = 0; i < nDots; i++) {
    color c = color(map(i, 0, nDots, 0, 255), 255, 255);
    PImage dot = makeDot(100, 7, c);
    PVector startLocation = new PVector(map(i, 0, nDots - 1, 0, width), map(i, 0, nDots - 1, 0, height));
    PVector velocity = PVector.mult(PVector.fromAngle((i % 2) * PI + QUARTER_PI / 2), map(i, 0, nDots, 1, 4));
    MovingImage m = new MovingImage(dot, startLocation, velocity);
    m.setBlendMode(SCREEN);
    
    mp.seq(new PushCel(cel1, m));  // Add this dot as new layer to cel1
  }

  mp.seq(new CrossFade(120, cel0, cel1));  // CrossFade transition from cel0 to cel1
  mp.seq(new Wait(250));                   // Wait
  Sparkle sparkle = new Sparkle();         // Create Sparkle effect
  sparkle.threshold = 128;                 // Set threshold of Sparkle
  mp.seq(new PushCel(cel1, sparkle));      // Add Sparkle to cel1
  mp.seq(new Wait(250));                   // Wait
  mp.seq(new PopCel(cel0));                // Remove Mirror filter from cel0
  mp.seq(new CrossFade(120, cel1, cel0));  // CrossFade Transition from cel1 to cel0
                                           // Goto beginning of sequencer loop
}

void draw() {
  background(0);
  mp.update();
  mp.display();
}

