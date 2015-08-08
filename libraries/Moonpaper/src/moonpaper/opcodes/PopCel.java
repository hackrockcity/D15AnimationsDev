package moonpaper.opcodes;

import moonpaper.Cel;

public class PopCel extends MoonCodeEvent {
	private Cel cel;

	public PopCel(Cel cel_) {
		super();
		cel = cel_;
	}

	@Override
	public void exec() {
		cel.removeLast();
	}
}
