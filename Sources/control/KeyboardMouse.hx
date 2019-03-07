package control;

import kha.input.KeyCode;
import kha.input.Keyboard;

class KeyboardMouse extends Controller {
  var keyboard : Keyboard;

	public function new() {
    if (Keyboard.get() != null) Keyboard.get().notify(onKeyDown, onKeyUp);
	}
	
  function onKeyDown(key:KeyCode) {
    switch key {
      case KeyCode.W:
        gasDown = true;
      case KeyCode.A:
        leftDown = true;
      case KeyCode.S:
        brakeDown = true;
      case KeyCode.D:
        rightDown = true;
      case KeyCode.Shift:
        boostDown = true;
      default:
        null;
    }
  }

  function onKeyUp(key:KeyCode) {
    switch key {
      case KeyCode.W:
        gasDown = false;
      case KeyCode.A:
        leftDown = false;
      case KeyCode.S:
        brakeDown = false;
      case KeyCode.D:
        rightDown = false;
      case KeyCode.Shift:
        boostDown = false;
      default:
        null;
    }
  }

}