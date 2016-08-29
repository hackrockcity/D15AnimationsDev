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
  //mp.seq(new Line(1 * fps, cel1.getTransparency(), 255));

  /**
   Animation Ideas:
   UDP Simulator (sample and hold)
   
   Sequencer Fixes:
   */

  // TESTING: ----------------------------------------------------
  // SignTest
  //SignTester signTester = new SignTester(pixelMap, signStructure);
  //mp.seq(new PushCel(cel0, signTester));
  //mp.seq(new Wait(60 * fpm));

  // RGB!!!!
  ShootingStars shootingStars = new ShootingStars(pixelMap, teatro);
  mp.seq(new PushCel(cel0, shootingStars));  

  RGB rgb = new RGB(pixelMap, signStructure);
  mp.seq(new PushCel(cel0, rgb));  
  mp.seq(new Wait(60 * fps));
  mp.seq(new ExitSketch());


  // SECTION: SparkleSegment
  SparkleSegment sparkleSegment = new SparkleSegment(pixelMap, signStructure);
  mp.seq(new PushCel(cel0, sparkleSegment));
  mp.seq(new Wait(120 * fps));
  mp.seq(new Line(30 * fps, sparkleSegment.transparency, 0.0));



  // SECTION: Shooting Stars
  //ShootingStars shootingStars = new ShootingStars(pixelMap, allStructures);
  //mp.seq(new PushCel(cel0, shootingStars));  
  //mp.seq(new Wait(60 * fps));



  // SECTION: Default Gradient Plasma with some changes -----------------
  int plasmaDuration = 120 * fps;
  int plasmaWait = 120 * fps;
  Plasma plasmaSign = new Plasma(pixelMap, signStructure);
  plasmaSign.phaseInc = 0.001;
  mp.seq(new PatchSet(plasmaSign.nInc, (0.01)));
  mp.seq(new PatchSet(plasmaSign.transparency, 0.0));
  mp.seq(new Line(10 * fps, plasmaSign.transparency, 255.0));  
  mp.seq(new PushCel(cel0, plasmaSign));
  mp.seq(new Wait(30 * fps));
  mp.seq(new Line(1 * fps, shootingStars.transparency, 0.0));
  mp.seq(new Wait(10 * fps));
  mp.seq(new Wait(plasmaWait));
  mp.seq(new Line(plasmaDuration, plasmaSign.nInc, 0.1));
  mp.seq(new Wait(plasmaWait));
  mp.seq(new Line(1 * fps, plasmaSign.transparency, 0));
  mp.seq(new Wait(1 * fps));
  mp.seq(new PopCel(cel0));


  // SECTION: White Gradient --------------------------------------------
  int whitePlasmaDuration = 90 * fps;
  int whitePlasmaWait = 90 * fps;
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
  mp.seq(new PatchSet(whitePlasmaSign.transparency, 0.0));
  mp.seq(new Line(1 * fps, whitePlasmaSign.transparency, 255.0));
  mp.seq(new PatchSet(whitePlasmaSign.nInc, (0.5)));
  mp.seq(new Line(whitePlasmaDuration, whitePlasmaSign.nInc, 0.01));
  mp.seq(new PushCel(cel0, whitePlasmaSign));


  // Wait for Line Envelope
  mp.seq(new Wait(whitePlasmaDuration));

  // Wait until next change
  mp.seq(new Wait(whitePlasmaWait));




  //// SECTION: letterSegmentScroller
  int letterSegmentScrollerWait = 20 * fps;

  //mp.seq(new Line(30 * fps, cel1.getTransparency(), 255.0));  // Cels reversed. Big bug. Living with it.
  //mp.seq(new PatchSet(cel0.getTransparency(), 128.0));
  mp.seq(new PatchSet(cel1.getTransparency(), 255.0));
  LetterSegmentScroller letterSegmentScroller = new LetterSegmentScroller(pixelMap, signStructure); 
  //mp.seq(new PatchSet(letterSegmentScroller.transparency, 0.0));
  mp.seq(new PushCel(cel1, letterSegmentScroller));
  mp.seq(new Wait(5 * fps));
  mp.seq(new Line(20 * fps, whitePlasmaSign.transparency, 0.0));
  mp.seq(new Wait(letterSegmentScrollerWait));


  mp.seq(new PopCel(cel0));

  // SECTION: CrossyAnimation ---------------------------------------------------
  CrossyAnimation crossyAnimation = new CrossyAnimation(pixelMap, signStructure);
  mp.seq(new PatchSet(crossyAnimation.transparency, 255.0));
  mp.seq(new PatchSet(crossyAnimation.heliosOdds, 0.001));
  mp.seq(new Line(30 * fps, crossyAnimation.heliosOdds, 0.15));
  mp.seq(new PushCel(cel0, crossyAnimation));
  mp.seq(new Wait(30 * fps));
  mp.seq(new Line(30 * fps, letterSegmentScroller.transparency, 0.0));

  // FlickerLetter
  FlickerLetter flickerLetter = new FlickerLetter(pixelMap, signStructure);
  flickerLetter.min = 0.8;

  mp.seq(new PushCel(cel0, flickerLetter));
  int flickerWaitCounter = 0;
  int flickerWaitTime = 90 * fps;
  while (flickerWaitCounter < flickerWaitTime) {
    mp.seq(new PatchSet(flickerLetter.index, (int) random(9)));
    int w = 2 * fps / (int) random(1, 6);
    flickerWaitCounter += w;
    mp.seq(new Wait(w));
  }

  mp.seq(new PopCel(cel0));

  // SECTION: SparkleDecay ---------------------------------------------
  SparkleDecay sparkleDecay = new SparkleDecay(pixelMap, allStructures);
  sparkleDecay.odds = 0.001;
  mp.seq(new PatchSet(sparkleDecay.transparency, 0.0));
  mp.seq(new PushCel(cel0, sparkleDecay));

  mp.seq(new PatchSet(crossyAnimation.isGenerating, false));
  mp.seq(new Wait(20 * fps));
  mp.seq(new Line(3 * fps, crossyAnimation.transparency, 0.0));
  mp.seq(new Line(3 * fps, sparkleDecay.transparency, 255.0));
  mp.seq(new Wait(120 * fps));

  mp.seq(new ExitSketch());
}