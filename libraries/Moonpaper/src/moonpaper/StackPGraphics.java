package moonpaper;

import processing.core.PApplet;
import processing.core.PGraphics;
import processing.core.PVector;
import java.util.ArrayList;

public class StackPGraphics {
	private ArrayList<PGraphics> pgList;
	private ArrayList<PVector> dimensionsList;
	private PApplet papplet;

	public StackPGraphics(PApplet papplet_) {
		papplet = papplet_;
		pgList = new ArrayList<PGraphics>();
		dimensionsList = new ArrayList<PVector>();
	}

	StackPGraphics() {
		pgList = new ArrayList<PGraphics>();
		dimensionsList = new ArrayList<PVector>();
	}

	public PGraphics get() {
		return papplet.g;
	}

	/**
	 * Creates and returns copy of current PGraphics in stack.
	 * 
	 * @return PGraphics
	 */
	public PGraphics copy() {
		PGraphics pgCopy = papplet
				.createGraphics(papplet.width, papplet.height);
		pgCopy.clear();
		pgCopy.copy(papplet.g, 0, 0, papplet.g.width, papplet.g.height, 0, 0,
				papplet.g.width, papplet.g.height);
		return pgCopy;
	}

	public PGraphics push() {
		// TODO: Should copy current render type.
		PGraphics pg = papplet.createGraphics(papplet.width, papplet.height);
		pg.clear();
		return push(pg);
	}

	public PGraphics push(int w, int h) {
		// TODO: Should copy current render type.
		PGraphics pg = papplet.createGraphics(w, h);
		pg.clear();
		return push(pg);
	}

	public PGraphics push(int w, int h, String renderer) {
		PGraphics pg = papplet.createGraphics(w, h, renderer);
		pg.clear();
		return push(pg);
	}

	public PGraphics push(PGraphics pg) {
		pgList.add(papplet.g);
		dimensionsList.add(new PVector(papplet.width, papplet.height));
		papplet.g = pg;
		papplet.width = pg.width;
		papplet.height = pg.height;
		papplet.g.beginDraw();
		return papplet.g;
	}

	public PGraphics pushCopy() {
		// TODO: Should copy current render type.
		PGraphics pgCopy = papplet
				.createGraphics(papplet.width, papplet.height);
		pgCopy.clear();
		pgCopy.copy(papplet.g, 0, 0, papplet.g.width, papplet.g.height, 0, 0,
				papplet.g.width, papplet.g.height);
		return push(pgCopy);
	}

	public PGraphics pushCopy(PGraphics pg) {
		// TODO: Should copy current render type.
		PGraphics pgCopy = papplet.createGraphics(pg.width, pg.height);
		pgCopy.clear();
		pgCopy.copy(pg, 0, 0, pg.width, pg.height, 0, 0, pg.width, pg.height);
		return push(pgCopy);
	}

	public PGraphics pop() {
		papplet.g.endDraw();
		PGraphics pgReturn = papplet.g;
		papplet.g = pgList.remove(pgList.size() - 1);
		PVector d = dimensionsList.remove(dimensionsList.size() - 1);
		papplet.width = (int) d.x;
		papplet.height = (int) d.y;
		return pgReturn;
	}

	public PGraphics pop(int blendMode) {
		papplet.g.endDraw();
		PGraphics pgReturn = papplet.g;
		papplet.g = pgList.remove(pgList.size() - 1);
		PVector d = dimensionsList.remove(dimensionsList.size() - 1);
		papplet.width = (int) d.x;
		papplet.height = (int) d.y;
		// FIXME: PApplet.BLEND may not be what I originally thought it was.
		// Looking for the current blend mod, this is likely a constant.
		int blendTemp = PApplet.BLEND;
		papplet.blendMode(blendMode);
		papplet.image(pgReturn, 0, 0);
		papplet.blendMode(blendTemp);
		return pgReturn;
	}

	// TODO: CORNER / CENTER / etc. Also, rename.
	/*
	 * public void popBlendMode(int m) { } // Where to place the image when
	 * popped with args public PGraphics pop(int blendMode, int x, int y) {
	 * return papplet.createGraphics(1, 1); } // Where and size public PGraphics
	 * pop(int blendMode, int x, int y, int w, int h) { return
	 * papplet.createGraphics(1, 1); }
	 */
}
