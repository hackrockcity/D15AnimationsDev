void createSequence() {  
  int fpm = fps * 60;  // Frames-per-minute

  StructurePixelMap allStructures = new StructurePixelMap(pixelMap);

  mp = new Moonpaper(this);
  Cel cel0 = mp.createCel(width, height);

  // Start of sequence
  mp.seq(new ClearCels());
  mp.seq(new PushCel(cel0, pixelMap));

  // Plasma
  mp.seq(new PushCel(cel0, new Plasma(pixelMap, allStructures)));
  mp.seq(new Wait(60 * fps));



  // Exit sketch
  if (captureFrames) {
    mp.seq(new ExitSketch());
  }
}

