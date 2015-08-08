package moonpaper.opcodes;

import moonpaper.Moonpaper;

public abstract class MoonCode {
	Moonpaper controller;
	MoonCodeInterpreter interpreter;
	public boolean isInitialized = false;
	protected boolean releaseState = true;

	public MoonCode() {
	}

	public void exec() {
	}

	public void init() {
		isInitialized = true;
	}

	public void cleanup() {
		isInitialized = false;
	}

	public void setController(Moonpaper controller_) {
		controller = controller_;
	}
	
	public void setInterpreter(MoonCodeInterpreter interpreter_) {
		interpreter = interpreter_;		
	}

	protected final void hold() {
		releaseState = false;
	}

	protected final void release() {
		releaseState = true;
		cleanup();
	}

	public final boolean getRelease() {
		return releaseState;
	}
}