package moonpaper;

import java.util.ArrayList;
import java.util.Iterator;

import moonpaper.opcodes.*;
import processing.core.PApplet;

public final class Moonpaper {
	public final static String VERSION = "##library.prettyVersion##";
	private PApplet papplet;
	private ArrayList<Cel> cels;
	private MoonCodeInterpreter interpreter;
//	private boolean isRoot;

	public Moonpaper(PApplet pApplet_) {
		papplet = pApplet_;
		cels = new ArrayList<Cel>();
		interpreter = new MoonCodeInterpreter(this);
	}

	/**
	 * Return the version of the library.
	 * 
	 * @return String
	 */
	public static String version() {
		return VERSION;
	}

	public void addMoonpaper(Moonpaper newMoon) {
		// A moonpaper object can be controlled by another moonpaper object. In
		// essence, it's like adding a setlist.
	}

	public Cel createCel() {
		Cel cel = new Cel(papplet);
		cels.add(cel);
		return cel;
	}

	public Cel createCel(int width, int height) {
		Cel cel = new Cel(papplet, width, height);
		// TODO: Should this automatically add canvas?
		cels.add(cel);
		return cel;
	}

	public void display() {
		for (Cel c : cels) {
			c.display();
		}
	}

	public Iterator<Cel> getCelIterator() {
		return cels.iterator();
	}

	public void seq(MoonCode mooncode) {
		interpreter.add(mooncode);
	}

	public void update() {
		interpreter.update();
		for (Cel c : cels) {
			c.update();
		}
	}

	public void debugMe(String s, Object o) {
		String oName = o.getClass().getName();
		PApplet.println(s + ": " + oName);
	}
}