import hypermedia.net.*;
import moonpaper.*;


BroadcastReceiver broadcastReceiver;
int meter = 100;

// Send a PGraphics over UDP
class Broadcast {
  Object receiveHandler;
  PixelMap pixelMap;
  String ip;
  int port;
  UDP udp;
  PGraphics pg;
  int nPixels;
  int bufferSize;
  byte buffer[];

  Broadcast(Object receiveHandler, PixelMap pixelMap, String ip, int port) {
    this.receiveHandler = receiveHandler;
    this.pixelMap = pixelMap;
    this.ip = ip;
    this.port = port;

    setup();
  }

  private void setup() {
    nPixels = pixelMap.columns * pixelMap.rows;
    bufferSize =  3 * nPixels + 1;
    buffer = new byte[bufferSize];
    pg = pixelMap.pg;

    udp = new UDP(receiveHandler);
    udp.setReceiveHandler("broadcastReceiveHandler");
    udp.log(false);
    udp.listen(false);
  }

  void update() {
    try {
      pg.loadPixels();
      buffer[0] = 1;  // Header. Always 1.

      for (int i = 0; i < nPixels; i++) {
        int offset = i * 3 + 1;
        int c = pg.pixels[i];

        buffer[offset] = byte((c >> 16) & 0xFF);     // Red 
        buffer[offset + 1] = byte((c >> 8) & 0xFF);  // Blue
        buffer[offset + 2] = byte(c & 0xFF);         // Green
      }
    }
    catch (Exception e) {
      println("frame: " + frameCount + "  Broadcast.update() frame dropped");
    }
    send();
  }

  void send() {
    try {
      udp.send(buffer, ip, port);
    }
    catch (Exception e) {
      println("frame: " + frameCount + "  Broadcast.send() frame dropped");
    }
  }
}

// Receive UDP data, and write int o PG.
class BroadcastReceiver {
  Object receiveHandler;
  PixelMap pixelMap;
  String ip;
  int port;
  UDP udp;
  PGraphics pg;
  int nPixels;
  int bufferSize;
  byte buffer[];

  BroadcastReceiver(Object receiveHandler, PixelMap pixelMap, String ip, int port) {
    this.receiveHandler = receiveHandler;
    this.pixelMap = pixelMap;
    this.ip = ip;
    this.port = port;

    setup();
  }

  protected void setup() {
    nPixels = pixelMap.columns * pixelMap.rows;
    bufferSize =  3 * nPixels + 1;
    buffer = new byte[bufferSize];
    pg = pixelMap.pg;

    udp = new UDP(receiveHandler, port);
    udp.setReceiveHandler("broadcastReceiveHandler");
    udp.log(false);
    udp.listen(true);
  }

  public void receive(byte[] data, String ip, int port) {
    if (data.length != bufferSize || data[0] != 1) {
      return;
    }

    pg.loadPixels();

    for (int i = 0; i < nPixels; i++) {
      int offset = i * 3 + 1;

      pg.pixels[i] = 0xFF000000 |         // Alpha
        ((data[offset] & 0xFF) << 16) |     // Red
        ((data[offset + 1] & 0xFF) << 8) |  // Green
        (data[offset + 2] & 0xFF);          // Blue
    }

    pg.updatePixels();
  }
}

// Hander for receive UDP data.
void broadcastReceiveHandler(byte[] data, String ip, int port) {
  broadcastReceiver.receive(data, ip, port);
}
class DisplayableStructure extends Displayable {
  PixelMap pixelMap;
  PGraphics pixelMapPG;
  Structure structure;
  PGraphics pg;            // Portion of structure, initialized in child
  Patchable<Integer> theBlendMode;
  Patchable<Float> transparency;

  DisplayableStructure(PixelMap pixelMap, Structure structure) {
    this.pixelMap = pixelMap;
    this.structure = structure;
    pixelMapPG = this.pixelMap.pg;
    theBlendMode = new Patchable<Integer>(BLEND);
    transparency = new Patchable<Float>(255.0);
  }
}

class DisplayableStrips extends DisplayableStructure {
  Strips strips;
  int rowOffset;

  DisplayableStrips(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
    setup();
  }

  void setup() {
    rowOffset = structure.rowOffset;
    strips = structure.strips;
    pg = createGraphics(structure.getMaxWidth(), strips.size());
  }

  void display() {
    pixelMapPG.beginDraw();
    pixelMapPG.blendMode(theBlendMode.value());
    pixelMapPG.tint(255, transparency.value());
    pixelMapPG.image(pg, 0, rowOffset);
    pixelMapPG.endDraw();
  }
}


class DisplayableLEDs extends DisplayableStrips {
  ArrayList<LEDs> ledMatrix;
  LEDs leds;
  int maxStripLength;

  DisplayableLEDs(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
    //    setup();
  }

  void setup() {
    super.setup();
    leds = new LEDs();
    maxStripLength = strips.getMaxStripLength();

    // Create LED Matrix that has a 1 to 1 ordered relationship to
    // the LEDs in the strip
    ledMatrix = new ArrayList<LEDs>();
    int nRows = strips.size();

    for (int row = 0; row < nRows; row++) {
      Strip strip = strips.get(row);
      int nCols = strip.nLights;
      LEDs stripLeds = new LEDs();

      for (int col = 0; col < nCols; col++) {
        LED thisLed = new LED();
        LED led = strip.leds.get(col);

        thisLed.position = led.position.get();
        stripLeds.add(thisLed);
        leds.add(thisLed);
      }

      ledMatrix.add(stripLeds);
    }
  }

  void update() {
    pg.beginDraw();
    pg.clear();
    pg.loadPixels();

    int nRows = ledMatrix.size();

    for (int row = 0; row < nRows; row++) {
      LEDs stripLeds = ledMatrix.get(row);
      int nCols = stripLeds.size();
      int rowOffset = row * maxStripLength;

      for (int col = 0; col < nCols; col++) {
        LED led = stripLeds.get(col);
        pg.pixels[rowOffset + col] = led.c;
      }
    }

    pg.updatePixels();
    pg.endDraw();
  }

  void clear() {
    for (LED led : leds) {
      led.c = color(0, 0);
    }
  }
}

void loadStrips(Strips strips, String filename) {
  JSONArray values = loadJSONArray(filename);
  int nValues = values.size();

  for (int i = 0; i < nValues; i++) {
    JSONObject data = values.getJSONObject(i);
    int id = data.getInt("id");
    int density = data.getInt("density");
    int nLights = data.getInt("numberOfLights");
    JSONArray startPoint = data.getJSONArray("startPoint");
    JSONArray endPoint = data.getJSONArray("endPoint");

    float x1 = startPoint.getInt(0);
    float y1 = startPoint.getInt(1);
    float z1 = startPoint.getInt(2);
    float x2 = endPoint.getInt(0);
    float y2 = endPoint.getInt(1);
    float z2 = endPoint.getInt(2);
    float x3 = modelX(x1, y1, z1); 
    float y3 = modelY(x1, y1, z1); 
    float z3 = modelZ(x1, y1, z1); 
    float x4 = modelX(x2, y2, z2); 
    float y4 = modelY(x2, y2, z2); 
    float z4 = modelZ(x2, y2, z2); 

    PVector p1 = new PVector(x3, y3, z3);
    PVector p2 = new PVector(x4, y4, z4);
    strips.add(new Strip(p1, p2, density));
  }
}

void writeJSONStrips(Strips strips, String saveAs) {
  JSONArray values = new JSONArray();

  for (int i = 0; i < strips.size (); i++) {
    JSONObject data = new JSONObject();
    Strip strip = strips.get(i);

    data.setInt("id", i);
    data.setInt("density", strip.density);
    data.setInt("numberOfLights", strip.nLights);

    JSONArray p1 = new JSONArray();
    p1.setFloat(0, strip.p1.x);
    p1.setFloat(1, strip.p1.y);
    p1.setFloat(2, strip.p1.z);
    data.setJSONArray("startPoint", p1);

    // Capture individual LED positions    
    //    JSONArray lights = new JSONArray(); 
    //    for (int j = 0; j < strip.nLights; j++) {
    //      JSONArray pos = new JSONArray(); 
    //      LED led = strip.lights.get(j);
    //      pos.setFloat(0, led.position.x);
    //      pos.setFloat(1, led.position.y);
    //      pos.setFloat(2, led.position.z);
    //      lights.setJSONArray(j, pos); 
    //    }
    //    data.setJSONArray("pixelPosition", lights);

    JSONArray p2 = new JSONArray();
    p2.setFloat(0, strip.p2.x);
    p2.setFloat(1, strip.p2.y);
    p2.setFloat(2, strip.p2.z);    
    data.setJSONArray("endPoint", p2);

    values.setJSONObject(i, data);
  }

  println(values);
  saveJSONArray(values, saveAs);
}

class LED {
  PVector position;
  color c;

  LED() {
    this.position = new PVector();
    c = color(0);
  }

  LED(PVector position) {
    this.position = position;
    c = color(0);
  }

  void set(color c) {
    this.c = c;
  }
}
// LEDList or Strip or Channel
class LEDList extends ArrayList<LED> {
}
class LEDs extends LEDList {
}

// StripList of ChannelList
class LEDSegmentsList extends ArrayList<LEDList> {
}

// ChannelStripList or ChannelSegmentsList
class ChannelSegmentsList extends ArrayList<LEDSegmentsList> {
}


import moonpaper.*;

// PixelMap.createStructure()
// PixelMap.createPartialStructe()

class PixelMap extends Displayable {
  Strips strips;
  ArrayList<LED> leds;
  int rows = 0;
  int columns;
  PGraphics pg;
  int nLights;

  PixelMap() {
    strips = new Strips();
  }

  void addStrips(Strips theStrips) {
    strips.addAll(theStrips);
    rows += theStrips.size();
  }

  void finalize() {
    leds = new LEDs();
    columns = 0;

    for (Strip strip : strips) {
      columns = max(columns, strip.nLights);

      for (LED L : strip.leds) {
        leds.add(L);
        L.c = color(random(255));
      }
    }

    pg = createGraphics(columns, rows);
    pg.beginDraw();
    pg.background(255, 0, 0);
    pg.endDraw();
    nLights = leds.size();
  }

  void update() {
    //    pg.beginDraw();
    //    pg.background(255, 0, 0);
    //    pg.loadPixels();
    //
    //    for (int row = 0; row < rows; row++) {
    //      Strip strip = strips.get(row);
    //      int stripSize = strip.nLights;
    //      int rowOffset = row * pg.width;
    //      ArrayList<LED> leds = strip.leds;
    //
    //      for (int col = 0; col < stripSize; col++) {
    //        pg.pixels[rowOffset + col] = leds.get(col).c;
    //      }
    //    }
    //
    //    pg.updatePixels();
    //    pg.endDraw();
  }

  void display() {
    try {
      pg.clear();
      image(pg, 0, 0);
    }
    catch (Exception e) {
      println("Frame: " + frameCount + "  PixelMap.display() exception. Could not draw image");
    }
  }
}
class Strips extends ArrayList<Strip> {
  int getMaxStripLength() {
    int L = 0;
    int stripSize = size();
    for (Strip strip : this) {
      if (strip.nLights > L) {
        L = strip.nLights;
      }
    }
    return L;
  }
}

class Strip {
  PVector p1;
  PVector p2;
  int density;
  int nLights;
  ArrayList<LED> leds;

  Strip(PVector p1, PVector p2, int density) {
    this.p1 = p1;
    this.p2 = p2;
    this.density = density;
    nLights = ceil(dist(p1, p2) / meter * density);

    // Create positions for each LED
    leds = new ArrayList<LED>();    
    for (int i = 0; i < nLights; i++) {
      float n = i / float(nLights);
      PVector p = lerp(p1, p2, n);
      leds.add(new LED(p));
    }
  }
}

class Structures extends ArrayList<Structure> {
}

class Structure {
  PixelMap pixelMap;
  String filename;
  Strips strips;
  int rowOffset = 0;
  PGraphics loadTransformation;

  Structure(PixelMap pixelMap) {
    this.pixelMap = pixelMap;
  }

  Structure(PixelMap pixelMap, String filename) {
    this.pixelMap = pixelMap;
    this.filename = filename;
    loadTransformation = createGraphics(1, 1, P3D);  // P3D required to get 3D transformations
    setup();
  }  

  Structure(PixelMap pixelMap, String filename, PGraphics loadTransformation) {
    this.pixelMap = pixelMap;
    this.filename = filename;
    this.loadTransformation = loadTransformation;
    setup();
  }  

  void setup() {
    strips = new Strips();    
    loadFromJSON(filename);
    rowOffset = pixelMap.rows;
    this.pixelMap.addStrips(strips);
  }

  void loadFromJSON(String filename) {
    JSONArray values = loadJSONArray(filename);
    int nValues = values.size();

    for (int i = 0; i < nValues; i++) {
      JSONObject data = values.getJSONObject(i);
      int id = data.getInt("id");
      int density = data.getInt("density");
      int nLights = data.getInt("numberOfLights");
      JSONArray startPoint = data.getJSONArray("startPoint");
      JSONArray endPoint = data.getJSONArray("endPoint");

      // Apply transformations
      float x1 = startPoint.getInt(0);
      float y1 = startPoint.getInt(1);
      float z1 = startPoint.getInt(2);
      float x2 = endPoint.getInt(0);
      float y2 = endPoint.getInt(1);
      float z2 = endPoint.getInt(2);
      float x3 = loadTransformation.modelX(x1, y1, z1); 
      float y3 = loadTransformation.modelY(x1, y1, z1); 
      float z3 = loadTransformation.modelZ(x1, y1, z1); 
      float x4 = loadTransformation.modelX(x2, y2, z2); 
      float y4 = loadTransformation.modelY(x2, y2, z2); 
      float z4 = loadTransformation.modelZ(x2, y2, z2); 

      PVector p1 = new PVector(x3, y3, z3);
      PVector p2 = new PVector(x4, y4, z4);

      strips.add(new Strip(p1, p2, density));
    }
  }

  int getMaxWidth() {
    int w = 0;
    for (Strip strip : strips) {
      int size = strip.nLights;

      if (size > w) {
        w = size;
      }
    }
    return w;
  }

  // getBox
  // getHeight
  // getDepth
  // getXBoundaries
  // etc...
}

class ComboStructure extends Structure {
  ComboStructure(PixelMap pixelMap, Structures structures) {
    super(pixelMap);
  }
}

class StructurePixelMap extends Structure {
  StructurePixelMap(PixelMap pixelMap) {
    super(pixelMap);
    setup();
  }

  void setup() {
    strips = new Strips();
    strips.addAll(pixelMap.strips);
    rowOffset = 0;
    //      this.pixelMap.addStrips(strips);
  }
}

// Distance between two PVectors
float dist(PVector p1, PVector p2) {
  return dist(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
}

// Interpolate between two PVectors
PVector lerp(PVector p1, PVector p2, float amt) {
  float x = lerp(p1.x, p2.x, amt);
  float y = lerp(p1.y, p2.y, amt);
  float z = lerp(p1.z, p2.z, amt);

  return new PVector(x, y, z);
}

// Convert point to include matrix translation
PVector transPVector(float x, float y, float z) {
  float x1 = modelX(x, y, z);
  float y1 = modelY(x, y, z);
  float z1 = modelZ(x, y, z);
  return new PVector(x1, y1, z1);
}

// Convert point to include matrix translation
PVector transPVector(PVector p) {
  return transPVector(p.x, p.y, p.z);
}

// Inches to Centimeters
float inchesToCM(float inches) {
  return inches / 0.393701;
}