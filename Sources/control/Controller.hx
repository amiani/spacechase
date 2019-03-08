package control;

import net.InputArray;
import hxbit.Serializable;

class Controller implements Serializable {
	var _input : Input;
	var latestFrame = -1;
	public var input(get, never) : Input;
	@:s public var inputHistory = new Array<Input>();

	public function new() {
		_input = new Input();
	}


	public function get_input() {
		return _input;
	}
	/*
	function get_unconfirmedInputs() {
		return inputHistory.slice(confirmedFrame);
	}

	public function getInputSince(frame:Int):Array<Input> {
		if (frame > latestFrame)
			trace('Warning: Trying to access future inputs');

		return inputHistory.slice(frame);
	}
	*/

	public function update(dt:Float, frame, confirmedFrame:Int) {
		_input.frame = frame;
		inputHistory.push(new Input(_input));
		var i = inputHistory[0];
		trace('i.frame: '+i.frame+' confirmedFrame: '+confirmedFrame);
		/*
		for (x in inputHistory) {
			trace('input frame: '+x.frame);
		}
		*/
		while (i.frame <= confirmedFrame) {
			i = inputHistory.shift();
			trace('shifted input');
		}
		trace('inputHistory length: '+inputHistory.length);
		trace('confirmed Frame: '+confirmedFrame);
		//latestFrame = frame;
		return _input;
	}

	public function getInputArray() {
		return new InputArray(inputHistory);
	}
}