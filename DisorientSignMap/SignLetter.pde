// SignLetter is more or less a conversion from d14signmask.png to an object.
abstract class SignLetter {
  int nChannels = 4;
  float spacer = 1;  // Space between pixels
  int xOffset = -3;
  int yOffset = -3;
  LEDList ledList = new LEDList();
  LEDSegmentsList ledSegmentsList = new LEDSegmentsList();  // All segments 
  LEDSegmentsList channelList = new LEDSegmentsList();  // All LEDS per channel in a letter
  ChannelSegmentsList channelSegmentsList = new ChannelSegmentsList();   // Individual strips in a channel

  SignLetter() {
    // Initialize lists
    for (int i = 0; i < nChannels; i++) {
      channelList.add(new LEDList());
      channelSegmentsList.add(new LEDSegmentsList());
    }
  }
  
  // Zero out all LEDs, making them transparent
  void clear() {
    for (LED led : ledList) {
      led.c = 0;
    }
  }

  // Add strip given two points and the channel
  protected void add(int x0, int y0, int x1, int y1, int channelIndex) {
    // Create strip
    LEDList strip = new LEDList();

    print(this.getClass().getSimpleName() + " Channel " + channelIndex + "  nLeds: ");
    // Horizontal strip
    if (y0 == y1) {
      int stripLength = (x1 - x0) / 4;
      int direction = stripLength > 0 ? 1 : -1;
      stripLength = abs(stripLength) + 1;

      for (int v = 0; v < stripLength; v++) {
        int x = x0 + v * 4 * direction;
        PVector p = new PVector((x + xOffset) / (4 / spacer), (y0 + yOffset) / (4 / spacer));
        //channel.add(p);
        strip.add(new LED(p));
      }
      println(stripLength);
    }
    // Vertical strip
    else if (x0 == x1) {
      int stripLength = (y1 - y0) / 4;
      int direction = stripLength > 0 ? 1 : -1;
      stripLength = abs(stripLength) + 1;

      for (int v = 0; v < stripLength; v++) {
        int y = y0 + v * 4 * direction;
        PVector p = new PVector((x0 + xOffset) / (4 / spacer), (y + yOffset) / (4 / spacer));
        strip.add(new LED(p));
      }
      println(stripLength);
    }
    // Error
    else {
      println("Illegal strip added:");
      println(x0 + ", " + y0 + ", " + x1 + ", " + y1 + ", " + channelIndex);
      exit();
    }

    // Add LEDs to their channel
    LEDList channel = channelList.get(channelIndex);
    channel.addAll(strip);

    // Add all leds to ledList
    ledList.addAll(channel);

    // Track segments
    ledSegmentsList.add(strip);

    // Add strip to stripList
    channelSegmentsList.get(channelIndex).add(strip);
  }

  // Display this letter. Used for debugging.
  void displayPixels() {
    color[] colors = {color(255, 128, 0), color(255, 180, 0), color(255, 0, 255), color(212, 32, 128)}; 

    pushStyle();
    noStroke();
    colorMode(HSB);
    int counter = 0;
    for (LEDList channel : channelList) {
      //fill(counter * 64, 255, 255);
      fill(colors[counter]);
      counter++;
      for (LED led : channel) {
        rect(led.position.x, led.position.y, 1, 1);
      }
    }
    popStyle();
  }

  // Display the LEDs of a channel
  void displayChannel(int channelIndex) {
    // Display all channels if index is less than 0
    if (channelIndex < 0) {
      displayPixels();
    // Display specified channel's LEDs
    } else {
      LEDList ledList = channelList.get(channelIndex);
      for (LED led : ledList) {
        rect(led.position.x, led.position.y, 1, 1);
      }
    }
  }
}