import hypermedia.net.*;
import moonpaper.*;
import moonpaper.opcodes.*;

import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

float lightSize = 4;  // Size of LEDs
float eyeHeight = 170;

Strips strips;
PVector theCamera = new PVector(0, eyeHeight, 0);
PixelMap pixelMap;
String ip = "localhost";
int port = 9999;


PeasyCam g_pCamera;

PShape teatro_model;


void drawPlane() {
  float corner = 10000;
  pushStyle();
  fill(64);  
  beginShape();
  vertex(corner, 0, corner);
  vertex(corner, 0, -corner);
  vertex(-corner, 0, -corner);
  vertex(-corner, 0, corner);
  endShape(CLOSE);
  popStyle();
}

void setup() {
  size(1600, 1200, P3D);
  frameRate(60);
  
  //g_pCamera = new PeasyCam(this, 0, 1.2, 0, 4);
  g_pCamera = new PeasyCam(this, 0, 400, 0, 3200);
  g_pCamera.setMinimumDistance(100);
  g_pCamera.setMaximumDistance(5000);
  g_pCamera.setWheelScale(1);
  //g_pCamera.setYawRotationMode();

  g_pCamera.rotateX(PI);
  g_pCamera.rotateY(-0.2);

  // Fix the front clipping plane
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), cameraZ/1000.0, cameraZ*50.0);

  // Setup Virtual Installation  
  strips = new Strips();

  // Load teatro
  Strips teatro = new Strips();
  loadStrips(teatro, "../teatro.json");
  strips.addAll(teatro);
  //teatro_model = loadShape("../teatro.obj");

  // Load asterix
  pushMatrix();
  //  scale(1, -1, 1);
  translate(0, 0, -2000);
  Strips asterix = new Strips();
  loadStrips(asterix, "../asterix.json");
  for (Strip strip : asterix) {
    for (LED led : strip.leds) {
      led.position.y *= -1;
    }
  }
  popMatrix();
  strips.addAll(asterix);

  // Load sign
  Strips sign = new Strips();
  loadStrips(sign, "../sign.json");
  strips.addAll(sign);

  // Generate PixelMap
  pixelMap = new PixelMap();
  pixelMap.addStrips(strips);
  pixelMap.finalize();

  // Receiver
  broadcastReceiver = new BroadcastReceiver(this, pixelMap, ip, port);
}

void pixelMapToStrips(PixelMap pixelMap, Strips strips) {
  int rows = strips.size();
  PGraphics pg = pixelMap.pg;
  pg.loadPixels();

  for (int row = 0; row < rows; row++) {
    Strip strip = strips.get(row);
    ArrayList<LED> lights = strip.leds;
    int cols = strip.nLights;
    int rowOffset = row * pixelMap.columns;

    for (int col = 0; col < cols; col++) {
      LED led = lights.get(col);
      led.c = pg.pixels[rowOffset + col];
    }
  }
}

void draw() {
  background(32);
  pushMatrix();

//  // Reorient Plane
//  rotateX(PI);
//  translate(width / 2.0, -500);

//  // Set Camera
//  theCamera.x = map(mouseX, 0, width, -width * 5, width * 5);
//  theCamera.z = map(mouseY, 0, height, 500, -3700);
//  camera(
//  theCamera.x, theCamera.y, theCamera.z, 
//  0.0, eyeHeight * 2, 500.0, 
//  0.0, -1.0, 0.0);

  // Draw landscape and structure  
  drawPlane();

  pushMatrix();
  scale(30);
  rotateX(-PI/2);
  rotateZ(PI);
  shape(teatro_model, 0, 0);
  popMatrix();

  pushStyle();
  noStroke();

  broadcastReceiver.draw();
  pixelMapToStrips(pixelMap, strips);
  
  for (Strip strip : strips) {
    for (LED led : strip.leds) {
      pushMatrix();
      PVector p = led.position;
      fill(led.c);
      translate(p.x, p.y, p.z);
      box(lightSize);
      popMatrix();
    }
  }
  
  popStyle();
  popMatrix();
}