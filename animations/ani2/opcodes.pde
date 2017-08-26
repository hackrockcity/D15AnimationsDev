import moonpaper.Patchable;

public class Saw extends MoonCodeGenerator {
  private int nFrames;
  private int counter;
  private float phase = 1.0;
  private float phaseInc = 0;
  private Patchable<Float> value;

  public Saw(int nFrames, float bpm, Patchable<Float> value) {
    this.nFrames = nFrames;
    phaseInc = -0.04;
    this.value = value;
    this.counter = nFrames;
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
      release();
    }
  }
}
