package moonpaper.opcodes;

import moonpaper.Cel;

public class FadeIn extends MoonCodeHold {
	private Cel cel;

	private int nFrames;
	private int counter;
	private float inc;

	public FadeIn(int nFrames_, Cel cel_) {
		nFrames = nFrames_;
		cel = cel_;
	}

	@Override
	public void init() {
		super.init();
		counter = nFrames;
		inc = 1 / (float) nFrames;
		cel.setTransparency(0);
		cel.setActive(true);
	}

	@Override
	public void exec() {
		counter--;
		float ratio = 1 - counter * inc;
		cel.setTransparency(ratio * 255);
				
		if (counter <= 0) {
			cel.setTransparency(255);
			release();
		}
	}	
}
