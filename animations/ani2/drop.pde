class Drop extends DisplayableLEDs {
  float top = 100000;
  float bot = -100000;
  float y;
  float ySpeed = 10;
  float w;
  Patchable<Float> transparency = new Patchable<Float>(0.0);
  color c1;
  color c2;

  Drop(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
    findDimensions();
    c1 = pink;
    c2 = orange;
  }

  void findDimensions() {
    // Find top an bottom of the structure
    for (LED led : leds) {
      top = min(top, led.position.y);
      bot = max(bot, led.position.y);
    }
    w = (bot-top)*0.75;
    // y = top;
    y = random(bot, top);
  }


  void update() {
    y += ySpeed;
    if (y > bot + w)
      y = top + w;

    for (LED led : leds) {
      if (led.position.y < y &&
          led.position.y > y - w)
      {
        led.c = taperedLerpColor(c1, c2, (y-led.position.y)/w);
      }
      else if (y > bot && led.position.y < y-bot+top) {
        //println(y-bot);
        led.c = taperedLerpColor(c1, c2, (y-bot+top-led.position.y)/w);
      }
      else {
        led.c = color(0, 0);
      }

      led.c = lerpColor(color(0, 0), led.c, transparency.value());
    }

    super.update();
  }

  color taperedLerpColor(color c1, color c2, float amt) {
    color c = lerpColor(c1, c2, amt);

    if (amt < 0.1) {
      c = lerpColor(c, color(0), (0.1-amt)*10);
    }
    else if (amt > 0.9) {
      c = lerpColor(c, color(0), (amt-0.9)*10);
    }
    //else if (amt > 0.40 && amt < 0.50) {
    //  c = lerpColor(c, color(255), (amt-0.40)*10);
    //}
    //else if (amt > 0.50 && amt < 0.60) {
    //  c = lerpColor(c, color(255), (0.60-amt)*10);
    //}


    return c;
  }
}
