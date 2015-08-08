/*

MovinLED is a simple animation that moves a pixel through each LED in a targeted
structure.

About extending DisplayableLEDs
-------------------------------

DisplayableLEDs is a class for when you want to target individual LEDs in a structure.
Usually, the scenario will be when you are writing an animation that targets LEDs by
their position in 3D space.

For example:
  for (LED led : leds) {
    if (led.position.x < 0) {
      led.c = color(255, 0, 0);  // Set LED to red if left of center
    }
    else {
      led.c = color(0, 0, 255);  // Otherwise, set LED to blue
    }
  }

*/

class MovingLED extends DisplayableLEDs {
  color pixelColor = color(255);
  int counter = 0;

  MovingLED(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
  }

  void update() {
    // Sets all LED.c to transparent
    clear();  

    // Cycle through each LED in targeted structure
    LED led = leds.get(counter);
    led.c = pixelColor;
    counter = (counter + 1) % leds.size();

    // Always call super.update() last. The super will automagically map the LED to
    // the correct position on the pixelMap
    super.update();
  }

  // For children class of DisplayableLEDs, there will rarely be a reason
  // to override the display() method, since changes to leds are made directly
  // to existing instances.
  //
  // The super.display() will automatically map and draw leds to the associated
  // strips, and then to the main PixelMap
}

