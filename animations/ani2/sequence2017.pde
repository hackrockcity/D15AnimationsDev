void createSequence2017() {
  int fpm = fps * 60;  // Frames-per-minute
  StructurePixelMap allStructures = new StructurePixelMap(pixelMap);
  mp = new Moonpaper(this);
  Cel cel0 = mp.createCel(width, height);
  Cel cel1 = mp.createCel(width, height);

  // INIT
  mp.seq(new ClearCels());
  mp.seq(new PushCel(cel0, pixelMap));
  mp.seq(new PatchSet(cel0.getTransparency(), 255.0));
  mp.seq(new PushCel(cel1, pixelMap));
  mp.seq(new PatchSet(cel1.getTransparency(), 0.0));

  // Fade in cel
  //mp.seq(new Line(1 * fps, cel0.getTransparency(), 255));
  //mp.seq(new Line(1 * fps, cel1.getTransparency(), 255));

  // MAIN SEQUENCE STARTS HERE -------------------------------------------------
  int duration = 4 * fps;  // Time between sections

  // SECTION: Shooting Stars
  ShootingStars shootingStars = new ShootingStars(pixelMap, allStructures);
  mp.seq(new PatchSet(shootingStars.nStarsPerFrame, 20));
  mp.seq(new PushCel(cel0, shootingStars));
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

  // // White Plasma for Teatro
  Plasma whitePlasmaTeatro = new Plasma(pixelMap, teatro, whiteGradient);
  mp.seq(new PatchSet(whitePlasmaTeatro.nInc, (0.1)));
  mp.seq(new Line(whitePlasmaDuration, whitePlasmaTeatro.nInc, 0.005));
  mp.seq(new PushCel(cel0, whitePlasmaTeatro));

  // // Colorize stars
  ArrayList<Integer> shootingStarsPink = new ArrayList<Integer>();
  shootingStarsPink.add(pink);
  mp.seq(new SetShootStarsColors(shootingStars, shootingStarsPink));
  mp.seq(new PatchSet(shootingStars.nStarsPerFrame, 10));
  mp.seq(new Line(whitePlasmaDuration, shootingStars.transparency, 255.0));

  // // Wait for Line Envelope
  mp.seq(new Wait(whitePlasmaDuration));
  //
  // // Wait until next change
  mp.seq(new Wait(whitePlasmaWait));


  mp.seq(new PopCel(cel0));
  // //// Fade out Plasma
  mp.seq(new Line(20 * fps, whitePlasmaTeatro.transparency, 0.0));

  // // SECTION: SparkleDecay ---------------------------------------------
  SparkleDecay sparkleDecay = new SparkleDecay(pixelMap, allStructures);
  sparkleDecay.odds = 0.005;

  mp.seq(new PushCel(cel0, sparkleDecay));

  mp.seq(new Wait(20 * fps));
  mp.seq(new Line(duration / 3, sparkleDecay.transparency, 255.0));
  mp.seq(new Wait(duration));

  mp.seq(new ExitSketch());
}
