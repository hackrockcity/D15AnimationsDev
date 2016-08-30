class Sign {
  LEDList ledList = new LEDList();  // Flattened list of all the sign's LEDs
  LEDSegmentsList ledSegmentsList = new LEDSegmentsList();
  private ArrayList<SignLetter> letterList = new ArrayList<SignLetter>();  // The letters
  LEDSegmentsList allChannelsList = new LEDSegmentsList();  // Each channel from each ledder

  int w = 0;
  int h = 0;

  Sign() {
    letterList.add(new SignLetterD());
    letterList.add(new SignLetterI());
    letterList.add(new SignLetterS());
    letterList.add(new SignLetterO());
    letterList.add(new SignLetterR());
    letterList.add(new SignLetterI2());
    letterList.add(new SignLetterE());
    letterList.add(new SignLetterN());
    letterList.add(new SignLetterT());
    createLEDList();
    createLEDSegmentsList();
    createAllChannelsList();
    setDimensions();
    displayNumPixelsPerLetter();
  }

  private void createAllChannelsList() {
    for (SignLetter signLetter : letterList) {
      for (LEDList ledList : signLetter.channelList) {
        allChannelsList.add(ledList);
      }
    }
  }

  // Display LEDs
  void display() {
    pushStyle();
    noStroke();
    for (LED led : ledList) {
      fill(led.c);
      rect(led.position.x, led.position.y, 1, 1);
    }
    popStyle();
  }

  void clear() {
    for (SignLetter letter : letterList) {
      letter.clear();
    }
  }

  void set(PGraphics pg) {
    if (pg.width < w || pg.height < h) {
      println("Error: Sign.set(PGraphics pg). The PG is too small");
      return;
    }

    pg.loadPixels();
    for (LED led : ledList) {
      led.c = pg.pixels[(int) led.position.x + (int) led.position.y * pg.width];
    }
  }

  // Display information
  void displayNumPixelsPerLetter() {
    for (SignLetter letter : letterList) {
      int counter = 0;
      for (LEDList channel : letter.channelList) {
        counter += channel.size();
      }
      println(letter.getClass().getSimpleName() + " total: " + counter);
    }
  }

  // Show the pixels on the screen. Used for debugging
  void displayPixels() {
    for (SignLetter letter : letterList) {
      letter.displayPixels();
    }
  }

  // Display a single channel for all letters
  void displayChannel(int channelIndex) {
    if (channelIndex < 0) {
      displayPixels();
    } else {
      for (SignLetter letter : letterList) {
        letter.displayChannel(channelIndex);
      }
    }
  }

  // Display a single letter
  void displayLetter(int letterIndex) {
    SignLetter letter = letterList.get(letterIndex);
    letter.displayPixels();
  }

  // Display a single with channel control
  void displayLetter(int letterIndex, int channelIndex) {
    SignLetter letter = letterList.get(letterIndex);
    letter.displayChannel(channelIndex);
  }

  // Flatten signs and channels to a single LEDlist.
  private void createLEDList() {
    for (SignLetter letter : letterList) {
      for (LEDList l : letter.channelList) {
        ledList.addAll(l);
      }
    }
  }

  // Flatten segments to a single LEDlist.
  private void createLEDSegmentsList() {
    for (SignLetter letter : letterList) {
      for (LEDList ledSegment : letter.ledSegmentsList) {
        ledSegmentsList.add(ledSegment);
      }
    }
  }

  // Set the width and height
  private void setDimensions() {
    for (LED led : ledList) {
      w = (int) max(w, led.position.x + 1);
      h = (int) max(h, led.position.y + 1);
    }
  }
}

// SignLetter is more or less a conversion from d14signmask.png to an object.
abstract class SignLetter {
  boolean displayInfo = true;
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


    // Horizontal strip
    if (y0 == y1) {
      int stripLength = (x1 - x0) / 4;
      int direction = stripLength > 0 ? 1 : -1;
      stripLength = abs(stripLength) + 1;

      for (int v = 0; v < stripLength; v++) {
        int x = x0 + v * 4 * direction;
        PVector p = new PVector((x + xOffset) / (4 / spacer), (y0 + yOffset) / (4 / spacer));
        strip.add(new LED(p));
      }
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
    }
    // Error
    else {
      println("Illegal strip added:");
      println(x0 + ", " + y0 + ", " + x1 + ", " + y1 + ", " + channelIndex);
      exit();
    }

    if (displayInfo) {
      print(this.getClass().getSimpleName() + " Channel " + channelIndex + "  nLeds: ");
      println(strip.size());
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

class SignLetterD extends SignLetter {
  SignLetterD() {
    // Channel 0
    add(3, 107, 3, 11, 1);
    add(3, 3, 119, 3, 1);
    add(139, 23, 139, 95, 1);
    add(119, 115, 3, 115, 1);

    // Channel 1 
    add(11, 99, 11, 19, 0);
    add(11, 11, 111, 11, 0);
    add(131, 23, 131, 95, 0);
    add(119, 107, 11, 107, 0);

    // Channel 2 
    add(19, 91, 19, 15, 3);
    add(19, 19, 119, 19, 3);
    add(123, 23, 123, 95, 3);
    add(119, 99, 19, 99, 3);

    // Channel 3 
    add(27, 91, 27, 27, 2);
    add(31, 27, 115, 27, 2);
    add(115, 31, 115, 91, 2);
    add(111, 91, 31, 91, 2);
  }
}

class SignLetterI extends SignLetter {
  SignLetterI() {
    // Remove unnecessary channels
    // TODO: Janky code warning
    channelSegmentsList.remove(2);
    channelSegmentsList.remove(2);
    channelList.remove(2);
    channelList.remove(2);

    // Channel 0
    add(181, 115, 181, 51, 1);
    add(181, 23, 181, 3, 1);
    add(189, 3, 189, 23, 1);
    add(189, 51, 189, 115, 1);
    add(197, 115, 197, 51, 1);
    add(197, 23, 197, 3, 1);
    add(205, 3, 205, 23, 1);
    add(205, 51, 205, 115, 1);
  }
}

class SignLetterS extends SignLetter {
  SignLetterS() {
    // Channel 0
    add(248, 115, 364, 115, 1);
    add(384, 95, 384, 63, 1);
    add(368, 47, 272, 47, 1);
    add(272, 43, 272, 27, 1);
    add(276, 27, 384, 27, 1);

    // Channel 1
    add(248, 107, 364, 107, 0);
    add(376, 95, 376, 63, 0);
    add(364, 55, 264, 55, 0);
    add(264, 51, 264, 19, 0);
    add(268, 19, 384, 19, 0);

    // Channel 2
    add(248, 99, 364, 99, 3);
    add(368, 95, 368, 63, 3);
    add(364, 63, 264, 63, 3);
    add(256, 51, 256, 19, 3);
    add(268, 11, 384, 11, 3);

    // Channel 3
    add(248, 91, 360, 91, 2);
    add(360, 87, 360, 71, 2);
    add(356, 71, 264, 71, 2);
    add(248, 51, 248, 19, 2);
    add(268, 3, 384, 3, 2);
  }
}

class SignLetterO extends SignLetter {
  SignLetterO() {
    // Channel 0
    add(426, 95, 426, 19, 3);
    add(446, 3, 546, 3, 3);
    add(566, 23, 566, 99, 3);
    add(546, 115, 446, 115, 3);

    // Channel 1
    add(434, 95, 434, 19, 2);
    add(446, 11, 546, 11, 2);
    add(558, 23, 558, 99, 2);
    add(546, 107, 446, 107, 2);

    // Channel 2
    add(442, 91, 442, 23, 1);
    add(446, 19, 546, 19, 1);
    add(550, 27, 550, 95, 1);
    add(546, 99, 438, 99, 1);

    // Channel 3
    add(450, 83, 450, 27, 0);
    add(454, 27, 542, 27, 0);
    add(542, 35, 542, 91, 0);
    add(538, 91, 450, 91, 0);
  }
}

class SignLetterR extends SignLetter {
  SignLetterR() {
    // Channel 0
    add(609, 115, 609, 11, 1);
    add(617, 3, 729, 3, 1);
    add(749, 19, 749, 51, 1);
    add(749, 95, 749, 115, 1);
    add(721, 59, 637, 59, 1);

    // Channel 1
    add(617, 115, 617, 19, 2);
    add(625, 11, 729, 11, 2);
    add(741, 19, 741, 51, 2);
    add(741, 95, 741, 115, 2);
    add(729, 67, 617, 67, 2);

    // Channel 2
    add(625, 115, 625, 27, 3);
    add(629, 19, 729, 19, 3);
    add(733, 31, 733, 115, 3);
    add(729, 75, 633, 75, 3);

    // Channel 3
    add(633, 115, 633, 87, 0);
    add(633, 59, 633, 27, 0);
    add(637, 27, 725, 27, 0);
    add(725, 31, 725, 59, 0);
    add(725, 91, 725, 115, 0);
    add(717, 99, 717, 87, 0);
    add(709, 87, 709, 99, 0);
    add(721, 83, 637, 83, 0);
  }
}

class SignLetterI2 extends SignLetter {
  SignLetterI2() {
    // Remove unnecessary channels
    // TODO: Janky code warning
    //channelList.remove(1);

    // Channel 0
    add(791, 115, 791, 51, 1);
    add(791, 23, 791, 3, 1);
    add(799, 3, 799, 23, 1);
    add(799, 51, 799, 115, 1);
    add(807, 115, 807, 51, 1);
    add(807, 23, 807, 3, 1);
    add(815, 3, 815, 23, 1);
    add(815, 51, 815, 115, 1);

    channelSegmentsList.remove(2);
    channelSegmentsList.remove(2);
    //channelSegmentsList.remove(1);
    channelList.remove(2);
    channelList.remove(2);
  }
}

class SignLetterE extends SignLetter {
  SignLetterE() {
    // Channel 0
    add(977, 115, 877, 115, 1);
    add(857, 95, 857, 19, 1);
    add(877, 3, 977, 3, 1);
    add(997, 23, 997, 71, 1);
    add(989, 71, 885, 71, 1);

    // Channel 1
    add(977, 107, 877, 107, 0);
    add(865, 95, 865, 19, 0);
    add(877, 11, 977, 11, 0);
    add(989, 23, 989, 63, 0);
    add(981, 63, 877, 63, 0);

    // Channel 2
    add(977, 99, 877, 99, 3);
    add(873, 95, 873, 19, 3);
    add(877, 19, 977, 19, 3);
    add(981, 23, 981, 55, 3);
    add(973, 55, 877, 55, 3);

    // Channel 3
    add(977, 91, 881, 91, 2);
    add(881, 87, 881, 75, 2);
    add(881, 47, 881, 27, 2);
    add(885, 27, 969, 27, 2);
    add(973, 27, 973, 47, 2);
    add(969, 47, 885, 47, 2);
  }
}

class SignLetterN extends SignLetter {
  SignLetterN() {
    // Channel 0
    add(1040, 115, 1040, 11, 3);
    add(1040, 3, 1156, 3, 3);
    add(1176, 27, 1176, 115, 3);

    // Channel 1
    add(1048, 115, 1048, 23, 1);
    add(1048, 11, 1156, 11, 1);
    add(1168, 27, 1168, 115, 1);

    // Channel 2
    add(1056, 115, 1056, 31, 2);
    add(1056, 19, 1156, 19, 2);
    add(1160, 31, 1160, 115, 2);

    // Channel 3
    add(1064, 115, 1064, 39, 0);
    add(1064, 27, 1148, 27, 0);
    add(1152, 39, 1152, 115, 0);
  }
}

class SignLetterT extends SignLetter {
  SignLetterT() {
    // Remove unnecessary channels
    // TODO: Janky code warning
    channelSegmentsList.remove(2);
    channelSegmentsList.remove(2);
    channelList.remove(2);
    channelList.remove(2);

    // Channel 0
    add(1270, 115, 1270, 39, 1);
    add(1278, 39, 1278, 115, 1);
    add(1286, 115, 1286, 39, 1);
    add(1294, 39, 1294, 115, 1);

    // Channel 1
    add(1218, 27, 1346, 27, 0);
    add(1346, 19, 1218, 19, 0);
    add(1218, 11, 1346, 11, 0);
    //add(1346, 3, 1218, 3, 0);  // original
    add(1346, 3, 1206, 3, 0);  // Faking to get 135
    
    // Fake Channel
    //add(0, 0, 540, 0, 2);
  }
}