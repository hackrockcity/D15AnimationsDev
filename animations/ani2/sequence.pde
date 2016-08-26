void createSequence() {  
  int fpm = fps * 60;  // Frames-per-minute
  StructurePixelMap allStructures = new StructurePixelMap(pixelMap);
  mp = new Moonpaper(this);
  Cel cel0 = mp.createCel(width, height);
  Cel cel1 = mp.createCel(width, height);

  // Start of sequence
  mp.seq(new ClearCels());
  mp.seq(new PushCel(cel0, pixelMap));
  mp.seq(new PatchSet(cel0.getTransparency(), 0.0));
  mp.seq(new PushCel(cel1, pixelMap));
  mp.seq(new PatchSet(cel1.getTransparency(), 0.0));



  // Fade in cel
  mp.seq(new Line(1 * fps, cel0.getTransparency(), 255));

  //SparkleDecay sp2 = new SparkleDecay(pixelMap, teatro);
  //mp.seq(new PushCel(cel0, sp2));
  //mp.seq(new PatchSet(sp.transparency, 0.0));
  //mp.seq(new Line(5 * fps, sp.transparency, 255.0));


  // Plasma
  //Plasma defaultPlasma = new Plasma(pixelMap, allStructures);
  //mp.seq(new PatchSet(defaultPlasma.transparency, 255.0));
  //mp.seq(new PushCel(cel0, defaultPlasma));



  // Crossfade Plasma to SparkleDecay
  //SparkleDecay sp = new SparkleDecay(pixelMap, allStructures);
  //mp.seq(new PushCel(cel0, sp));
  //mp.seq(new PatchSet(sp.transparency, 0.0));
  //mp.seq(new Line(5 * fps, sp.transparency, 255.0));
  //mp.seq(new Line(5 * fps, defaultPlasma.transparency, 0.0));


  // SECTION: Default Gradient Plasma with some changes -----------------
  int plasmaDuration = 90 * fps;
  int plasmaWait = 10 * fps;
  Plasma plasmaSign = new Plasma(pixelMap, signStructure);
  plasmaSign.phaseInc = 0.001;
  //plasmaSign.xInc = 0.0;
  //plasmaSign.yInc = 0.000001;
  mp.seq(new PatchSet(plasmaSign.nInc, (0.01)));
  mp.seq(new PatchSet(plasmaSign.transparency, 0.0));
  mp.seq(new Line(1 * fps, plasmaSign.transparency, 255.0));
  mp.seq(new PushCel(cel0, plasmaSign));
  mp.seq(new Wait(plasmaWait));
  mp.seq(new Line(plasmaDuration, plasmaSign.nInc, 0.5));

  mp.seq(new Wait(plasmaDuration));
  mp.seq(new Wait(plasmaWait));
  mp.seq(new PopCel(cel0));


  // SECTION: White Gradient --------------------------------------------
  int whitePlasmaDuration = 90 * fps;
  int whitePlasmaWait = 10 * fps;
  //int whitePlasmaDuration = 3 * fps;
  //int whitePlasmaWait = 3 * fps;

  Gradient whiteGradient = new Gradient();
  float whiteGradientWidth1 = 0.05;
  float whiteGradientWidth2 = 0.5;
  whiteGradient.add(color(255), whiteGradientWidth1);
  whiteGradient.add(color(255, 0), whiteGradientWidth2);
  whiteGradient.add(color(255, 0), whiteGradientWidth1);
  whiteGradient.add(color(255), whiteGradientWidth1);
  whiteGradient.add(color(255, 0), whiteGradientWidth2);
  whiteGradient.add(color(255, 0), whiteGradientWidth1);
  whiteGradient.add(color(255), whiteGradientWidth1);
  whiteGradient.add(color(255, 0), whiteGradientWidth2);
  whiteGradient.add(color(255, 0), whiteGradientWidth1);

  // White Plasma for Teatro
  //Plasma whitePlasmaTeatro = new Plasma(pixelMap, teatro, whiteGradient);
  //mp.seq(new PatchSet(whitePlasmaTeatro.nInc, (0.1)));
  //mp.seq(new PatchSet(whitePlasmaTeatro.transparency, 0.0));
  //mp.seq(new Line(1 * fps, whitePlasmaTeatro.transparency, 255.0));
  //mp.seq(new Line(whitePlasmaDuration, whitePlasmaTeatro.nInc, 0.005));
  //mp.seq(new PushCel(cel0, whitePlasmaTeatro));

  // White Plasma for Sign
  Plasma whitePlasmaSign = new Plasma(pixelMap, signStructure, whiteGradient);
  mp.seq(new PatchSet(whitePlasmaSign.nInc, (0.5)));
  mp.seq(new Line(whitePlasmaDuration, whitePlasmaSign.nInc, 0.01));
  mp.seq(new PushCel(cel0, whitePlasmaSign));


  // Wait for Line Envelope
  mp.seq(new Wait(whitePlasmaDuration));

  // Wait until next change
  mp.seq(new Wait(whitePlasmaWait));




  // SECTION: letterSegmentScroller
  int letterSegmentScrollerWait = 10 * fps;

  //mp.seq(new Line(30 * fps, cel1.getTransparency(), 255.0));  // Cels reversed. Big bug. Living with it.
  //mp.seq(new PatchSet(cel0.getTransparency(), 128.0));
  mp.seq(new PatchSet(cel1.getTransparency(), 255.0));
  LetterSegmentScroller letterSegmentScroller = new LetterSegmentScroller(pixelMap, signStructure); 
  //mp.seq(new PatchSet(letterSegmentScroller.transparency, 0.0));
  //mp.seq(new Line(1 * fps, letterSegmentScroller.transparency, 255.0));
  mp.seq(new PushCel(cel1, letterSegmentScroller));
  mp.seq(new Wait(4 * fps));
  //mp.seq(new PopCel(cel1));
  //mp.seq(new Line(10 * fps, cel0.getTransparency(), 0));


  mp.seq(new Wait(letterSegmentScrollerWait));


  //mp.seq(new ClearCels());
  mp.seq(new PopCel(cel0));


  // Sign Animation Test 3
  SignAnimationTest3 signAnimationTest3 = new SignAnimationTest3(pixelMap, signStructure);
  mp.seq(new PatchSet(signAnimationTest3.transparency, 255.0));
  mp.seq(new PushCel(cel0, signAnimationTest3));
  mp.seq(new Wait(60 * fps));
  mp.seq(new PopCel(cel0));

  // Sign Animation Test 2
  SignAnimationTest2 signAnimationTest2 = new SignAnimationTest2(pixelMap, signStructure); 
  mp.seq(new PatchSet(signAnimationTest2.transparency, 255.0));
  mp.seq(new PushCel(cel0, signAnimationTest2));
  mp.seq(new Wait(60 * fps));

  //mp.seq(new ClearCels());


  // Crossnoise
  //CrossNoise crossNoise = new CrossNoise(pixelMap, signStructure); 
  //mp.seq(new PatchSet(crossNoise.transparency, 255.0));
  //mp.seq(new PushCel(cel0, crossNoise));
  //mp.seq(new Wait(1 * fpm));

  //  mp.seq(new PushCel(cel0, new StripSweep(pixelMap, allStructures)));
  //  mp.seq(new PushCel(cel0, new CrossNoise(pixelMap, allStructures)));
  //  mp.seq(new PushCel(cel0, defaultPlasma2));
  //  mp.seq(new Wait(2 * fpm));


  // Crossfade SparkleDecay to WhiteGradient




  // Exit sketch
  if (captureFrames) {
    mp.seq(new ExitSketch());
  }
}