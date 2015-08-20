void createSequence() {
  StructurePixelMap allStructures = new StructurePixelMap(pixelMap);
  
  mp = new Moonpaper(this);
  Cel cel0 = mp.createCel(width, height);
  
  mp.seq(new ClearCels());
  mp.seq(new PushCel(cel0, pixelMap));
  mp.seq(new PushCel(cel0, new StripSweep(pixelMap, allStructures)));
  mp.seq(new Wait(120));
  mp.seq(new Wait(60 * 2));                                        // Run for two minutes
//  mp.seq(new ExitSketch());
}
