package net;

import control.Input;
import hxbit.Serializable;

class InputArray implements Serializable {
	@:s public var inputs : Array<Input>;
	public function new(inputs:Array<Input>) {
		this.inputs = inputs;
	}
}