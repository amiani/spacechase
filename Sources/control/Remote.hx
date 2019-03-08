package control;

import hx.concurrent.collection.Queue;

class Remote extends Controller {
	public var inputBuffer(default, null) = new Queue<Input>();
	public var lastFrame = -1;
	public function new() super();

	override function get_input() {
		while (_input.frame < Spacechase.frame && inputBuffer.length > 0) {
			_input = inputBuffer.pop();
		}
		return _input;
	}

	public function addInputs(inputs:Array<Input>) {
		trace('inputs: '+inputs);
		for (input in inputs) {
			if (input.frame > lastFrame)
				inputBuffer.push(input);
		}
	}
}