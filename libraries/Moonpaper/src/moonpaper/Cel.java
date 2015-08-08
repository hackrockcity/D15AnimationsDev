package moonpaper;

import java.util.ArrayList;

import processing.core.PGraphics;
import processing.core.PApplet;

public class Cel extends Displayable {
	public PGraphics pg;
	private ArrayList<Displayable> displayables;
	private PApplet papplet;
	private StackPGraphics stackPG;
	private boolean isActiveState = true;
	private Patchable<Float> transparency = new Patchable<Float>(255.0f);

	public Cel(PApplet parent_) {
		papplet = parent_;
		pg = papplet.createGraphics(papplet.width, papplet.height);
		stackPG = new StackPGraphics(papplet);
		displayables = new ArrayList<Displayable>();
	}

	public Cel(PApplet parent_, int width, int height) {
		papplet = parent_;
		pg = papplet.createGraphics(width, height);
		stackPG = new StackPGraphics(papplet);
		displayables = new ArrayList<Displayable>();
	}

	@Override
	public void update() {
		if (isActiveState) {
			pg.clear();
			stackPG.push(pg);
			for (Displayable d : displayables) {
				d.update();

				// TODO: I don't like this. Do something about it.
				if (d instanceof Filter) {
					Filter f = (Filter) d;
					if (f.getClearOnDisplay()) {
						pg.clear();
					}
				}
			}
			stackPG.pop();
		}
	}

	@Override
	public void display() {
		if (isActiveState && transparency.value() >= 1.0) {
			stackPG.push(pg);
			for (Displayable d : displayables) {
				papplet.blendMode(d.getBlendMode());
				d.display();
				papplet.blendMode(PApplet.BLEND);
			}
			stackPG.pop();
			if (transparency.value() <= 254.0) {
				papplet.tint(255, transparency.value());
			} else {
				papplet.noTint();
			}
			papplet.image(pg, 0, 0);
		}
	}

	public void add(Displayable d) {
		stackPG.push(pg);
		d.setStackPGraphics(stackPG);
		d.init();
		stackPG.pop();
		displayables.add(d);
	}

	public void removeLast() {
		int size = displayables.size(); 
		if (size > 0) {
			displayables.remove(size - 1);
		}
	}
	
	public void setActive(boolean isActiveState_) {
		isActiveState = isActiveState_;
	}

	public boolean isActive() {
		return isActiveState;
	}

	public void clear() {
		displayables.clear();
	}

	public final Patchable<Float> getTransparency() {
		return transparency;
	}

	public final void setTransparency(float f) {
		transparency = new Patchable<Float>(f);
	}
}
