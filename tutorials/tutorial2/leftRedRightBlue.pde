/*

 LeftRedRightBlue is a demonstration of how to change individual LED
 colors in 3D cartesian space. Anything left of x.0 is red, and the
 rest is set to blue.
 
 */

class LeftRedRightBlue extends DisplayableLEDs {
  LeftRedRightBlue(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
  }

  void update() {
    for (LED led : leds) {
      if (led.position.x < 0) {
        led.c = color(255, 0, 0);  // Set LED to red if left of center
      } else {
        led.c = color(0, 0, 255);  // Otherwise, set LED to blue
      }
    }

    // Always call super.update() last. The super will automagically map the LED to
    // the correct position on the pixelMap
    super.update();
  }
}

