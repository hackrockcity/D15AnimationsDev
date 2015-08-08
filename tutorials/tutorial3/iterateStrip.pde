/*

 IterateStrip cycles through each individual strip, setting it to orange
 in the order in which the are stored in he original JSON.
 
 About extending DisplayableStrips
 ---------------------------------
 
 This class is about targeting either strips or the local PGraphics.

 To understand this, let's take a look at the relationship between
 strips and PGraphics.

 Strips are loaded in order from the JSON file. Each strip is a row
 in the local pg. So strips.get(0) would be the top row of pixels
 in the pg.

 However, strips come in varying sizes. The pg will be as wide as
 the longest strip in the structure.

 Depending on your structure, you can treat the pg as a 2D display,
 though results will vary depending how the strips are loaded. A
 jumbotron would be easy to do, but 3D structures may be perceived
 as if they are loaded in a random order.

 One more thing. The local pg in this class is smaller in height
 and width than the global pixelMap pg. So you'll see it writes to
 a mostly square area to the bottom left. It's on the bottom because
 the asterix is the second structure loaded into the global pixelMap.
 It's to the left because the strips are shorter than the teatros.

 */

class IterateStrip extends DisplayableStrips {
  color theColor = color(255, 128, 0);
  int counter = 0;

  IterateStrip(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
  }

  void update() {
    super.update();
    if (frameCount % 10 == 0) {
      counter = (counter + 1) % strips.size();
    }
  }

  void display() {
    pg.beginDraw();
    pg.clear();
    pg.loadPixels();

    int y = counter;
    Strip strip = strips.get(y);
    int stripLength = strip.nLights;
    int yOffset = y * pg.width;

    for (int x = 0; x < stripLength; x++) {
      pg.pixels[yOffset + x] = color(255, 128, 0);
    } 

    pg.updatePixels();
    pg.endDraw();
    
    // Call super.display() at the end. This will copy this instant's local
    // PGraphics pg onto the pixelMap pg, with the proper offset.
    super.display();
  }
}
