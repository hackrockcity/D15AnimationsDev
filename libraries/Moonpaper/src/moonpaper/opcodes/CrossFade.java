package moonpaper.opcodes;

import moonpaper.Cel;

public class CrossFade extends MoonCodeHold {
	private Cel startingCel;
	private Cel endingCel;

	private int nFrames;
	private int counter;
	private float inc;

	public CrossFade(int nFrames_, Cel startingCel_, Cel endingCel_) {
		nFrames = nFrames_;
		startingCel = startingCel_;
		endingCel = endingCel_;
	}

	@Override
	public void init() {
		super.init();
		counter = nFrames;
		endingCel.setActive(true);
		endingCel.setTransparency(0);
		inc = 1 / (float) nFrames;
	}

	@Override
	public void exec() {
		counter--;
		float ratio = counter * inc;
		
		startingCel.setTransparency(ratio * 255);
		endingCel.setTransparency((1 - ratio) * 255);
				
		if (counter <= 0) {
			startingCel.setActive(false);
			endingCel.setTransparency(255);
			release();
		}
	}	
}
