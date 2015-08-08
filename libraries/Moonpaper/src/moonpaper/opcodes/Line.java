package moonpaper.opcodes;

import moonpaper.Patchable;

public class Line extends MoonCodeGenerator {
	private float start;
	private float end;
	private int nFrames;
	private int counter;
	private Patchable<Float> value;

	public Line(int nFrames_, float start_, float end_) {
		nFrames = nFrames_;
		start = start_;
		end = end_;
		value = new Patchable<Float>(start_);
	}

	public Line(int nFrames_, Patchable<Float> pf, float end_) {
		nFrames = nFrames_;
		end = end_;
		value = pf;
	}

	@Override
	public void init() {
		super.init();
		counter = nFrames;
		start = value.value();
	}

	@Override
	public void exec() {
		counter--;
		float amount = (float) counter / (float) nFrames;
		value.set(end + (start - end) * amount);
		if (counter <= 0) {
			release();
		}
	}
}
