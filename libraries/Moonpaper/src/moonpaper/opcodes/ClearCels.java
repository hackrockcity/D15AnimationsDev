package moonpaper.opcodes;

import java.util.Iterator;

import moonpaper.Cel;

public class ClearCels extends MoonCodeEvent {
	@Override
	public void exec() {
		Iterator<Cel> iterator = controller.getCelIterator();
		while (iterator.hasNext()) {
			Cel c = iterator.next();
			c.clear();
		}
	}
}
