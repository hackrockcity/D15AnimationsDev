class SignStructure extends Structure {
  Sign sign;

  SignStructure(PixelMap pixelMap, Sign sign) {
    super(pixelMap);
    this.sign = sign;
    setup();
  }

  void setup() {
    // This allows multiple structures in an animation
    rowOffset = pixelMap.rows;

    // Create strips
    strips = new Strips();

    // Create strip based on each sign channel.
    for (LEDList channel : sign.allChannelsList) {
      Strip strip = new Strip(channel);
      strips.add(strip);
    }

    pixelMap.addStrips(strips);
  }
}
  