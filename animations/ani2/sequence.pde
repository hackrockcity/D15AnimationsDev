void createSequence() {  
  int fpm = fps * 5;  // Frames-per-minute

  StructurePixelMap allStructures = new StructurePixelMap(pixelMap);

  mp = new Moonpaper(this);
  Cel cel0 = mp.createCel(width, height);


  // Start of sequence
  mp.seq(new ClearCels());
  mp.seq(new PushCel(cel0, pixelMap));
  mp.seq(new PatchSet(cel0.getTransparency(), 0.0));

  // Fade in cel
  mp.seq(new PatchSet(cel0.getTransparency(), 0.0));
  mp.seq(new Line(1 * fps, cel0.getTransparency(), 255));

  SparkleDecay sp = new SparkleDecay(pixelMap, allStructures);
  mp.seq(new PushCel(cel0, sp));
  //mp.seq(new PatchSet(sp.transparency, 0.0));
  //mp.seq(new Line(5 * fps, sp.transparency, 255.0));



  // Sign Animation Test 2
  SignAnimationTest2 signAnimationTest2 = new SignAnimationTest2(pixelMap, signStructure); 
  mp.seq(new PatchSet(signAnimationTest2.transparency, 255.0));
  mp.seq(new PushCel(cel0, signAnimationTest2));
  mp.seq(new Wait(1 * fpm));
  mp.seq(new PopCel(cel0));
  
  // Sign Animation Test 3
  SignAnimationTest3 signAnimationTest3 = new SignAnimationTest3(pixelMap, signStructure);
  mp.seq(new PatchSet(signAnimationTest3.transparency, 255.0));
  mp.seq(new PushCel(cel0, signAnimationTest3));
  mp.seq(new Wait(1 * fpm));
  mp.seq(new PopCel(cel0));
  
  // Sign Animation Test 4
  SignAnimationTest4 signAnimationTest4 = new SignAnimationTest4(pixelMap, signStructure); 
  mp.seq(new PatchSet(signAnimationTest4.transparency, 255.0));
  mp.seq(new PushCel(cel0, signAnimationTest4));
  mp.seq(new Wait(1 * fpm));
  mp.seq(new PopCel(cel0));

  // Crossnoise
  CrossNoise crossNoise = new CrossNoise(pixelMap, signStructure); 
  mp.seq(new PatchSet(crossNoise.transparency, 255.0));
  mp.seq(new PushCel(cel0, crossNoise));
  mp.seq(new Wait(1 * fpm));

  // Plasma
  Plasma defaultPlasma = new Plasma(pixelMap, allStructures);
  mp.seq(new PatchSet(defaultPlasma.transparency, 255.0));
  mp.seq(new PushCel(cel0, defaultPlasma));

  // Hold
  //  mp.seq(new Wait(1 * fpm));
  mp.seq(new Wait(5 * fps));


  // Crossfade Plasma to SparkleDecay
  SparkleDecay sp = new SparkleDecay(pixelMap, allStructures);
  mp.seq(new PushCel(cel0, sp));
  mp.seq(new PatchSet(sp.transparency, 0.0));
  mp.seq(new Line(5 * fps, sp.transparency, 255.0));
  mp.seq(new Line(5 * fps, defaultPlasma.transparency, 0.0));

  // Hold
  mp.seq(new Wait(10 * fps));


  //  mp.seq(new PushCel(cel0, new StripSweep(pixelMap, allStructures)));
  //  mp.seq(new PushCel(cel0, new CrossNoise(pixelMap, allStructures)));
  //  mp.seq(new PushCel(cel0, defaultPlasma2));
  //  mp.seq(new Wait(2 * fpm));


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

  // White Plasma
  Plasma whitePlasma = new Plasma(pixelMap, allStructures, whiteGradient);
  mp.seq(new PatchSet(whitePlasma.transparency, 0.0));
  mp.seq(new PushCel(cel0, whitePlasma));
  mp.seq(new Line(5 * fps, sp.transparency, 0.0));
  mp.seq(new Line(5 * fps, whitePlasma.transparency, 255.0));
  mp.seq(new Wait(5 * fpm));



  // Exit sketch
  if (captureFrames) {
    mp.seq(new ExitSketch());
  }
}