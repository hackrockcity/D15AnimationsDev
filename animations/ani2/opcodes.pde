import moonpaper.Patchable;

public class Saw extends MoonCodeGenerator {
  private int nFrames;
  private int counter;
  private float phase = 1.0;
  private float phaseInc = 0;
  private Patchable<Float> value;
  private float initialValue;

  public Saw(int nFrames, float phaseInc, Patchable<Float> value) {
    this.nFrames = nFrames;
    this.phaseInc = phaseInc;
    this.value = value;
    this.counter = nFrames;

    initialValue = value.value();
  }

  @Override
  public void init() {
    super.init();
    counter = nFrames;
  }

  @Override
  public void exec() {
    counter--;


    phase += phaseInc;
    if (phase < 0) {
      phase += 1.0;
    } else if (phase >= 1.0) {
      phase -= 1.0;
    }

    value.set(phase);

    // Release
    if (counter <= 0) {
      value.set(1.0);
      release();
    }
  }
}
