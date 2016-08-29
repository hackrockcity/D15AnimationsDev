import moonpaper.*;
import moonpaper.opcodes.*;

public class ExitSketch extends MoonCodeEvent {
  @Override
    public void exec() {
    println("ExitSketch.exec() at Frame " + frameCount);
    if (captureStream) {
      try {
        signStream.close();
      } 
      catch (IOException e) {
        println("Can't close file");
        exit();
      }
    }
    exit();
  }
}