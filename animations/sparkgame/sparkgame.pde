import hypermedia.net.*;
import moonpaper.*;

String teatroJSON = "../../teatro.json";
String asterixJSON = "../../asterix.json";
Structure teatro;
Structure asterix;
PixelMap pixelMap;  // PixelMap is the master canvas which all animations will draw to

// Broadcast
Broadcast broadcast;
String ip = "localhost"; 
int port = 6100;

// Animation
Game game;

void setupPixelMap() {
  // Setup Virtual LED Installation  
  pixelMap = new PixelMap();  // Create 2D PixelMap from strips

  // Create teatro structure
  teatro = new Structure(pixelMap, teatroJSON);

  // Create asterix structure
  // The load transformation allows us to apply transformations to the Structure
  // being loaded.
  PGraphics loadTransformation = createGraphics(1, 1, P3D);
  loadTransformation.pushMatrix();
  loadTransformation.scale(1, -1, 1);
  asterix = new Structure(pixelMap, asterixJSON, loadTransformation);
  loadTransformation.popMatrix();

  // Once all structures are loaded, finalize the pixelMap
  pixelMap.finalize();
}

void setup() {
  size(135, 108, P2D);

  // Load in structures and create master PixelMap
  setupPixelMap();

  // Setup Broadcasting
  broadcast = new Broadcast(this, pixelMap, ip, port);
  broadcast.pg = g;

  // Setup Animation
  game = new Game(pixelMap, asterix);
}

void draw() {
  background(0);

  // Update and display animation
  game.update();
  game.display();

  // Update pixelMap
  pixelMap.update();
  pixelMap.display();

  // Broadcast to simulator  
  broadcast.update();
}
