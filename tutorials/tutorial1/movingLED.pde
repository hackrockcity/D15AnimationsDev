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

