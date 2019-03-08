package control;

import hxbit.Serializable;

class Input implements Serializable {
	public function new(?input:Input) {
		if (input != null) {
			this.up = input.up;
			this.left = input.left;
			this.down = input.down;
			this.right = input.right;
			this.boost = input.boost;
			this.frame = input.frame;
		}
	}

	@:s public var up = false;
	@:s public var left = false;
	@:s public var down = false;
	@:s public var right = false;
	@:s public var boost = false;
	@:s public var frame = 0;

}