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
        _input.up = true;
      case KeyCode.A:
        _input.left = true;
      case KeyCode.S:
        _input.down = true;
      case KeyCode.D:
        _input.right = true;
      case KeyCode.Shift:
        _input.boost = true;
      default:
        null;
    }
  }

  function onKeyUp(key:KeyCode) {
    switch key {
      case KeyCode.W:
        _input.up = false;
      case KeyCode.A:
        _input.left = false;
      case KeyCode.S:
        _input.down = false;
      case KeyCode.D:
        _input.right = false;
      case KeyCode.Shift:
        _input.boost = false;
      default:
        null;
    }
  }
}