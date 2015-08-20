import moonpaper.*;
import moonpaper.opcodes.*;

public class ExitSketch extends MoonCodeEvent {
  @Override
  public void exec() {
    println("ExitSketch.exec() at Frame " + frameCount);
    exit();
  }
}
