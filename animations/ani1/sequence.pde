void createSequence() {  
  int fpm = fps * 60;  // Frames-per-minute

  StructurePixelMap allStructures = new StructurePixelMap(pixelMap);

  mp = new Moonpaper(this);
  Cel cel0 = mp.createCel(width, height);

  int hold = 1 * fpm;

  // Start of sequence
  mp.seq(new ClearCels());
  mp.seq(new PushCel(cel0, pixelMap));
  mp.seq(new PatchSet(cel0.getTransparency(), 0.0));

  // Fade in cel
  mp.seq(new PatchSet(cel0.getTransparency(), 0.0));
  mp.seq(new Line(5 * fps, cel0.getTransparency(), 255));




  // Testing PerlinSparkle
  PerlinSparkle defaultPerlinSparkle = new PerlinSparkle(pixelMap, allStructures);
  mp.seq(new PatchSet(defaultPerlinSparkle.transparency, 255.0));
  mp.seq(new PushCel(cel0, defaultPerlinSparkle));
  // Hold
  mp.seq(new Wait(10));





  // Plasma
  Plasma defaultPlasma = new Plasma(pixelMap, allStructures);
  mp.seq(new PatchSet(defaultPlasma.transparency, 255.0));
  mp.seq(new PushCel(cel0, defaultPlasma));
  
  // Hold
  mp.seq(new Wait(hold));

  // Crossfade Plasma to SparkleDecay
  SparkleDecay sp = new SparkleDecay(pixelMap, allStructures);
  mp.seq(new PushCel(cel0, sp));
  mp.seq(new PatchSet(sp.transparency, 0.0));
  mp.seq(new Line(5 * fps, sp.transparency, 255.0));
  mp.seq(new Line(5 * fps, defaultPlasma.transparency, 0.0));

  // Hold
  mp.seq(new Wait(hold));

  // Crossfade SparkleDecay to WhiteGradient
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
  Plasma whitePlasma = new Plasma(pixelMap, allStructures, whiteGradient);
  mp.seq(new PatchSet(whitePlasma.transparency, 0.0));
  mp.seq(new PushCel(cel0, whitePlasma));
  mp.seq(new Line(5 * fps, sp.transparency, 0.0));
  mp.seq(new Line(5 * fps, whitePlasma.transparency, 255.0));

  // Hold
  mp.seq(new Wait(1 * fpm));

  // Fadeout WhitePlasma
  mp.seq(new Line(5 * fps, whitePlasma.transparency, 0.0));
  mp.seq(new Wait(5 * fps));



  
//  mp.seq(new PushCel(cel0, new StripSweep(pixelMap, allStructures)));
//  mp.seq(new PushCel(cel0, new CrossNoise(pixelMap, allStructures)));
//  mp.seq(new PushCel(cel0, defaultPlasma2));
//  mp.seq(new Wait(2 * fpm));
  
  


  // Exit sketch
  if (captureFrames) {
    mp.seq(new ExitSketch());
  }
}

