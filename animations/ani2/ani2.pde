import hypermedia.net.*;
import moonpaper.*;
import moonpaper.opcodes.*;
import java.util.Iterator;
import java.io.*;

// Do you have a flag?
boolean isFastRender = false;
boolean captureFrames = true;
boolean captureStream = false;
boolean broadcastData = false;

// Save Stream
FileOutputStream signStream;
String signFile = "disorientSign";

// Colors
color orange = color(255, 48, 0);
color magenta = color(180, 0, 180);
color pink = color(212, 0, 128);
color white = color(255);
color black = color(0);

// Turn on frame capture
//String captureFolder = "./frames/";
String captureFolder = "./testframes/";

// Broadcast
Broadcast broadcast;
String ip = "localhost";  // For simulator
//String ip = "192.168.1.99";  // Side of container
int port = 9999;

// Set FrameRate
int fps = 60;        // Frames-per-second
int fpm = fps * 60;  // Frames-per-minute

// PixelMap and Structures
String teatroJSON = "../../scroller.json";
Structure teatro;
SignStructure signStructure;
PixelMap pixelMap;  // PixelMap is the master canvas which createSequence2017 animations will draw to
Moonpaper mp;

// Important
int teatroWidth = 405;
int teatroHeight = 8;

// Font / text / words / anagrams
FontDisorient2017  df = new FontDisorient2017 ();
ArrayList<String> words = new ArrayList<String>();

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
  // signStructure = new SignStructure(pixelMap, new Sign());

  // Once all structures are loaded, finalize the pixelMap
  pixelMap.finalize();
  surface.setSize(pixelMap.pg.width, pixelMap.pg.height); // Resize
  verifySize();  // Sanity
}

void settings() {
  size(1, 1, P2D);  // Set to P2D. Will resize once pixelMap is loaded
}

void setup() {
  randomSeed(2017);
  noiseSeed(2017);
  surface.setResizable(true);

  // Fastest possible if capturing
  if (isFastRender) {
   frameRate(480);
 } else {
   frameRate(fps);
  }

  // Load names
  loadWords();

  // Load in structures and create master PixelMap
  setupPixelMap();

  // Setup Broadcasting
  broadcast = new Broadcast(this, pixelMap, ip, port);
  //broadcast.pg = pixelMap.pg;
  broadcast.pg = g;

  // Create sequence
  createSequence2017();

  // Print dimension sketches
  println("Sketch dimensions: " + width, ", " + height);


  // Files
  try {
    //signStream = new FileOutputStream("/Users/jacobjoaquin/Documents/BM2016/D15AnimationsDev/animations/ani2/");
    signStream = new FileOutputStream("./disorientSignBytes");
  }
  catch (FileNotFoundException e) {
    println("file not found");
    exit();
  }

}

void draw() {
  background(0);

  // Update and display animation
  mp.update();
  mp.display();

  if (captureStream && frameCount == 1) {
    println("Capturing stream");
  }

  // Capture frame
  if (captureFrames) {
    saveFrame(captureFolder + "f########.png");
  }

  // Broadcast to simulator
  broadcast.update();

  // Save bytes
  if (captureStream) {
    try {
      int bufferLength = broadcast.buffer.length;

      for (int i = 0; i < bufferLength; i++) {
        signStream.write(broadcast.buffer[i]);
      }
    }
    catch (IOException e) {
      println(e);
      println("Can't write to buffer");
      println("FrameCount = " + frameCount);
      exit();
    }
  }
}
