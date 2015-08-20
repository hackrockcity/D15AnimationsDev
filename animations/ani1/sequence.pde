void createSequence() {  
  int fpm = fps * 60;  // Frames-per-minute

  StructurePixelMap allStructures = new StructurePixelMap(pixelMap);

  mp = new Moonpaper(this);
  Cel cel0 = mp.createCel(width, height);
  Cel cel1 = mp.createCel(width, height);

  // Start of sequence
  mp.seq(new ClearCels());
  mp.seq(new PushCel(cel0, pixelMap));
  mp.seq(new PushCel(cel1, pixelMap));
//  mp.seq(new PatchSet(cel0.getTransparency(), 0.0));
//  mp.seq(new PatchSet(cel1.getTransparency(), 0.0));

  // Fade-in cel0
//  mp.seq(new PatchSet(cel0.getTransparency(), 0.0));
//  mp.seq(new Line(2 * fps, cel0.getTransparency(), 255));

  // Plasma
  Plasma defaultPlasma = new Plasma(pixelMap, allStructures);
  mp.seq(new PatchSet(defaultPlasma.transparency, 255.0));
  mp.seq(new PushCel(cel0, defaultPlasma));
  mp.seq(new Wait(2 * fps));
  
  
  // Add Sparkle
  mp.seq(new PushCel(cel0, new SparkleDecay(pixelMap, allStructures)));
  
  
  mp.seq(new Wait(1 * fpm));

//  mp.seq(new Line(2 * fps, defaultPlasma.transparency, 0));


  Gradient whiteGradient = new Gradient();
  whiteGradient.add(color(255), 0.1);
  whiteGradient.add(color(255, 0), 0.4);
  whiteGradient.add(color(255, 0), 0.1);
  whiteGradient.add(color(255), 0.1);
  whiteGradient.add(color(255, 0), 0.4);
  whiteGradient.add(color(255, 0), 0.1);
  whiteGradient.add(color(255), 0.1);
  whiteGradient.add(color(255, 0), 0.4);
  whiteGradient.add(color(255, 0), 0.1);
  
  // White Plasma
  Plasma whitePlasma = new Plasma(pixelMap, allStructures, whiteGradient);
//  mp.seq(new CrossFade(10 * fps, cel0, cel1));
  mp.seq(new PushCel(cel0, whitePlasma));
  mp.seq(new Wait(5 * fpm));



  // Exit sketch
  if (captureFrames) {
    mp.seq(new ExitSketch());
  }
}

