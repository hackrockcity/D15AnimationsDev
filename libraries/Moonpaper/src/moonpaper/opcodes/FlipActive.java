package moonpaper.opcodes;

import java.util.Iterator;
import moonpaper.Cel;

public class FlipActive extends MoonCodeEvent {
	public FlipActive() {
		super();
	}

	@Override
	public void exec() {
		Iterator<Cel> iterator = controller.getCelIterator();
		while (iterator.hasNext()) {
			Cel c = iterator.next();
			c.setActive(!c.isActive());
		}
	}
}
