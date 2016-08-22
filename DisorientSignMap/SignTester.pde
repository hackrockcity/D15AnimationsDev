class SignTester {
  boolean displayAll = false;
  ArrayList<Integer> counters;

  SignTester() {
    resetCounters();
  }

  void update() {
    if (keyPressed) {
      if (key == 'a') {
        resetCounters();
      } else if (key == '1') {
        updateLetterStrip(0);
      } else if (key == '2') {
        updateLetterStrip(1);
      } else if (key == '3') {
        updateLetterStrip(2);
      } else if (key == '4') {
        updateLetterStrip(3);
      } else if (key == '5') {
        updateLetterStrip(4);
      } else if (key == '6') {
        updateLetterStrip(5);
      } else if (key == '7') {
        updateLetterStrip(6);
      } else if (key == '8') {
        updateLetterStrip(7);
      } else if (key == '9') {
        updateLetterStrip(8);
      }
    }

    if (displayAll) {
      sign.displayPixels();
    } else {
      for (int i = 0; i < 9; i++) {
        displayLetterTest(i, counters.get(i));
      }
    }
  }


  private void resetCounters() {
    displayAll = true;
    counters = new ArrayList<Integer>();
    for (int i = 0; i < 9; i++) {
      counters.add(-1);
    }
  }

  private void updateLetterStrip(int letterIndex) {
    displayAll = false;
    Integer c = counters.get(letterIndex);
    c = c + 1;
    if (c == 4) {
      c = -1;
    }
    counters.set(letterIndex, c);
  }

  private void displayLetterTest(int letterIndex, int channelIndex) {
    if (channelIndex == -1) {
      return;
    }
    SignLetter letter = sign.letterList.get(letterIndex);
    LEDSegmentsList segments = letter.channelSegmentsList.get(channelIndex);
    int nSegments = segments.size();
    println(nSegments);    
    pushStyle();
    colorMode(HSB);
    noStroke();
    for (int i = 0; i < nSegments; i++) {
      LEDList segment = segments.get(i);
      fill(i / (float) nSegments * 256, 255, 255);
      for (LED led : segment) {
        rect(led.position.x, led.position.y, 1, 1);
      }
    }
    popStyle();
  }
}