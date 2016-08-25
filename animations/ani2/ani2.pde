import hypermedia.net.*;
import moonpaper.*;
import moonpaper.opcodes.*;

// Broadcast
boolean broadcastData = true; 

// Colors
color orange = color(255, 80, 0);
color magenta = color(255, 0, 255);
color pink = color(240, 32, 180);

// Turn on frame capture
boolean captureFrames = false;
String captureFolder = "./frames/";

// Broadcast
Broadcast broadcast;
//String ip = "localhost";  // For simulator 
String ip = "192.168.7.2"; 
int port = 9999;

// Set FrameRate
int fps = 60;        // Frames-per-second

// PixelMap and Structures
String teatroJSON = "../../teatro16.json";
Structure teatro;
SignStructure signStructure;
PixelMap pixelMap;  // PixelMap is the master canvas which all animations will draw to
Moonpaper mp;

// Animation
void verifySize() {
  if (width != pixelMap.pg.width || height != pixelMap.pg.height) {
    println("Set size() in setup to this:");
    println("  size(" + pixelMap.pg.width + ", " + pixelMap.pg.height + ", P2D);");
    exit();
  }
}

void setupPixelMap() {
  // Setup Virtual LED Installation  
  pixelMap = new PixelMap();  // Create 2D PixelMap from strips

  // Create teatro structure
  teatro = new Structure(pixelMap, teatroJSON);

  // Create sign structure
  signStructure = new SignStructure(pixelMap, new Sign());

  // Once all structures are loaded, finalize the pixelMap
  pixelMap.finalize();
  surface.setSize(pixelMap.pg.width, pixelMap.pg.height); // Resize
  verifySize();  // Sanity
}

void settings() {
  size(1, 1, P2D);  // Set to P2D. Will resize once pixelMap is loaded
}

void setup() {
  surface.setResizable(true);
  frameRate(fps);

  // Load in structures and create master PixelMap
  setupPixelMap();

  // Setup Broadcasting
  broadcast = new Broadcast(this, pixelMap, ip, port);
  broadcast.pg = g;

  // Create sequence
  createSequence();

  // Print dimension sketches
  println("Sketch dimensions: " + width, ", " + height);
}

void draw() {
  background(0);

  // Update and display animation
  mp.update();
  mp.display();

  // Capture frame
  if (captureFrames) {
    saveFrame(captureFolder + "f########.png");
  }

  // Broadcast to simulator
  if (broadcastData) {
    broadcast.update();
  }
}