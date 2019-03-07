package control;

import hxbit.Serializable;

class Input implements Serializable {
	public function new() {}
	@:s public var up = false;
	@:s public var left = false;
	@:s public var down = false;
	@:s public var right = false;
	@:s public var boost = false;
	@:s public var frame : Int;
}

class Controller {
	public var input(get, null) : Input;
	public var inputHistory : Array<Input>;

	private function new() {
		inputHistory = new Array<Input>();
	}

	public function get_input(frame:Int) {
		input.frame = frame;
		return input;
	}

	public function update(dt:Float, frame) {
		input.frame = frame;
		inputHistory.push(input);
		return input;
	}
}