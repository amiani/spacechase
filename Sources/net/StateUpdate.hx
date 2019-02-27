package net;

import hxbit.Serializable;

class StateUpdate implements Serializable {
	@:s public var frame : Int;
	@:s public var nodes : Array<Node>;

	public function new(frame:Int, nodes:Array<Node>) {
		this.frame = frame;
		this.nodes = nodes;
	}
}