package moonpaper.opcodes;

public class Wait extends MoonCodeHold {
	private int nFrames;
	private int counter;

	public Wait(int nFrames_) {
		nFrames = nFrames_;
	}

	@Override
	public void init() {
		super.init();
		counter = nFrames;
	}

	@Override
	public void exec() {
		if (counter-- <= 0) {
			release();
		}
	}
}
