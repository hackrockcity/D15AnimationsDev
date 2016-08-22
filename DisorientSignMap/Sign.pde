class Sign {
  LEDList ledList = new LEDList();  // Flattened list of all the sign's LEDs
  LEDSegmentsList ledSegmentsList = new LEDSegmentsList();
  private ArrayList<SignLetter> letterList = new ArrayList<SignLetter>();  // The letters
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
    setDimensions();
    //displayNumPixelsPerLetter();
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

  //void setPixel(int i, color c) {
  //}

  //void get(int i) {
  //}


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