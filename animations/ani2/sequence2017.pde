void createSequence2017() {
  float sawInc = 0.033;
  StructurePixelMap allStructures = new StructurePixelMap(pixelMap);
  mp = new Moonpaper(this);
  Cel cel0 = mp.createCel(width, height);
  Cel cel1 = mp.createCel(width, height);

  // INIT
  int duration = 6 * fps;  // Time between sections

  mp.seq(new ClearCels());
  mp.seq(new PushCel(cel0, pixelMap));
  mp.seq(new PatchSet(cel0.getTransparency(), 255.0));
  mp.seq(new PushCel(cel1, pixelMap));
  mp.seq(new PatchSet(cel1.getTransparency(), 0.0));

  // Start Sparkle Scroller
  SparkleScroller sparkleScroller = new SparkleScroller(pixelMap, teatro);
  // sparkleScroller.setText(createLongString(words, "  "));
  sparkleScroller.setWords(words);
  mp.seq(new PushCel(cel0, sparkleScroller));
  // mp.seq(new Wait(duration / 2));

  // MAIN SEQUENCE STARTS HERE -------------------------------------------------
  for (int i = 0; i < 20; i++) {



    // SECTION: Shooting Stars
    ShootingStars shootingStars = new ShootingStars(pixelMap, allStructures);
    mp.seq(new PatchSet(shootingStars.nStarsPerFrame, 20));
    mp.seq(new PushCel(cel0, shootingStars));
    mp.seq(new Saw(duration + duration / 2, -sawInc, sparkleScroller.brightness));
    mp.seq(new Wait(duration));


    // SECTION: Default Gradient Plasma with some changes -----------------
    int plasmaDuration = duration;
    int plasmaWait = duration;

    Plasma plasmaTeatro = new Plasma(pixelMap, teatro);
    plasmaTeatro.phaseInc = 0.001;
    mp.seq(new PatchSet(plasmaTeatro.nInc, (0.01)));
    mp.seq(new PatchSet(plasmaTeatro.transparency, 0.0));
    mp.seq(new Line(duration / 3, plasmaTeatro.transparency, 255.0));
    mp.seq(new PushCel(cel0, plasmaTeatro));
    mp.seq(new Wait(duration));
    mp.seq(new Line(duration / 3, shootingStars.transparency, 0.0));
    mp.seq(new Wait(duration / 3));
    mp.seq(new Wait(plasmaWait));
    mp.seq(new Line(plasmaDuration, plasmaTeatro.nInc, 0.02));
    mp.seq(new Wait(plasmaWait));
    mp.seq(new Line(15, plasmaTeatro.transparency, 0));
    mp.seq(new Saw(15 * fps, -sawInc, sparkleScroller.brightness));
    mp.seq(new Wait(15));
    mp.seq(new PopCel(cel0));


    // // SECTION: White Gradient --------------------------------------------
    int whitePlasmaDuration = duration;
    int whitePlasmaWait = duration;

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
    Plasma whitePlasmaTeatro = new Plasma(pixelMap, teatro, whiteGradient);
    mp.seq(new PatchSet(whitePlasmaTeatro.nInc, (0.1)));
    mp.seq(new Line(whitePlasmaDuration, whitePlasmaTeatro.nInc, 0.005));
    mp.seq(new PushCel(cel0, whitePlasmaTeatro));

    // Wait for Line Envelope
    mp.seq(new Wait(whitePlasmaDuration * 2));

    // Wait until next change
    mp.seq(new Line(whitePlasmaDuration, whitePlasmaTeatro.transparency, 0.0));
    mp.seq(new Wait(whitePlasmaWait));
    mp.seq(new PopCel(cel0));

    // //// Fade out Plasma
    mp.seq(new Line(duration, whitePlasmaTeatro.transparency, 0.0));
    mp.seq(new Line(duration, shootingStars.transparency, 0.0));
    mp.seq(new Wait(duration / 4));
    mp.seq(new PopCel(cel0));
    // mp.seq(new PopCel(cel0));
  }

  mp.seq(new ExitSketch());
}
