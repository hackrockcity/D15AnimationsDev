class SignStructure extends Structure {
  PixelMap pixelMap;
  String filename = "";
  Strips strips;
  int rowOffset = 0;
  PGraphics loadTransformation;
  Sign sign;

  SignStructure(PixelMap pixelMap, Sign sign) {
    super(pixelMap);
    this.sign = sign;
    this.pixelMap = pixelMap;
    signInit();
  }

  void signInit() {
    //rowOffset = this.pixelMap.rows;  // This allows multiple structures in an animation

    // Create strips
    strips = new Strips();

    for (LEDList channel : sign.allChannelsList) {
      Strip strip = new Strip(channel);
      strips.add(strip);
    }
    println(strips.size());
    this.pixelMap.addStrips(strips);
  }

  void setup() {
    strips = new Strips(); 
    loadFromJSON(filename); 
    rowOffset = pixelMap.rows; 
    this.pixelMap.addStrips(strips);
  }

}