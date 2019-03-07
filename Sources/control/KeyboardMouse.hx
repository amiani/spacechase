package control;

import kha.input.KeyCode;
import kha.input.Keyboard;

class KeyboardMouse extends Controller {
	public function new() {
    super();
    if (Keyboard.get() != null) Keyboard.get().notify(onKeyDown, onKeyUp);
	}
	
  function onKeyDown(key:KeyCode) {
    switch key {
      case KeyCode.W:
        input.up = true;
      case KeyCode.A:
        input.left = true;
      case KeyCode.S:
        input.down = true;
      case KeyCode.D:
        input.right = true;
      case KeyCode.Shift:
        input.boost = true;
      default:
        null;
    }
  }

  function onKeyUp(key:KeyCode) {
    switch key {
      case KeyCode.W:
        input.up = false;
      case KeyCode.A:
        input.left = false;
      case KeyCode.S:
        input.down = false;
      case KeyCode.D:
        input.right = false;
      case KeyCode.Shift:
        input.boost = false;
      default:
        null;
    }
  }

}