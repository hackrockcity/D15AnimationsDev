void createSequence() {
  StructurePixelMap allStructures = new StructurePixelMap(pixelMap);
  
  mp = new Moonpaper(this);
  Cel cel0 = mp.createCel(width, height);
  
  mp.seq(new ClearCels());
  mp.seq(new PushCel(cel0, pixelMap));
  mp.seq(new PushCel(cel0, new Plasma(pixelMap, allStructures)));
  mp.seq(new Wait(120));
  mp.seq(new ExitSketch());
}
