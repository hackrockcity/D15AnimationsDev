package moonpaper.opcodes;

import java.util.ArrayList;
import java.util.Iterator;

import moonpaper.Moonpaper;

public final class MoonCodeInterpreter {
	private Moonpaper controller;
	private ArrayList<MoonCode> mooncodes;
	private ArrayList<MoonCodeGenerator> generators;
	private Iterator<MoonCode> iterator;
	private MoonCode currentMooncode;

	public MoonCodeInterpreter(Moonpaper controller_) {
		controller = controller_;
		mooncodes = new ArrayList<MoonCode>();
		generators = new ArrayList<MoonCodeGenerator>();
	}

	public void add(MoonCode mooncode) {
		mooncode.setInterpreter(this);
		mooncode.setController(controller);
		mooncodes.add(mooncode);
	}

	private void next() {
		if (!iterator.hasNext()) {
			iterator = mooncodes.iterator();
		}
		currentMooncode = iterator.next();
		currentMooncode.init();
	}

	public void update() {
		updateGenerators();
		updateMoonCode();
	}

	private void updateGenerators() {
		Iterator<MoonCodeGenerator> i = generators.iterator();
		while (i.hasNext()) {
			MoonCodeGenerator generator = i.next();
			generator.exec();
			if (generator.getRelease()) {
				i.remove();
			}
		}
	}

	private void updateMoonCode() {
		// TODO: This first block should be done elsewhere. But where? This may
		// require that Moonpaper.begin() and end() methods are added.
		if (iterator == null) {
			iterator = mooncodes.iterator();
			currentMooncode = iterator.next();
		}
		while (true) {
//			controller.debugMe("currentMoonCode()", currentMooncode);
			currentMooncode.exec();
			if (!currentMooncode.getRelease()) {
				if (currentMooncode instanceof MoonCodeGenerator) {
					generators.add((MoonCodeGenerator) currentMooncode);					
				} else if (currentMooncode instanceof MoonCodeHold) {
					return;
				}
			}
			next();
		}
	}
}
