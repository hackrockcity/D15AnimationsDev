package moonpaper;

//import processing.core.*;

public class Filter extends Displayable {
	private boolean clearDisplay = false;

	public void setClearOnDisplay(boolean clearDisplay_) {
		clearDisplay = clearDisplay_;
	}

	public boolean getClearOnDisplay() {
		return clearDisplay;
	}
}