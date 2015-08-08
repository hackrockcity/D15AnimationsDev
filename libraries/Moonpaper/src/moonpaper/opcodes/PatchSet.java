package moonpaper.opcodes;

import moonpaper.Patchable;

public class PatchSet<T> extends MoonCodeEvent {
	Patchable<T> destination;
	T source;
	
	public PatchSet(Patchable<T> destination, T source) {
		this.destination = destination;
		this.source = source;
	}
	
	@Override
	public void exec() {
		destination.set(source);
	}
}