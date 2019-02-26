import hx.concurrent.executor.*;
import hx.concurrent.event.*;

class Courier {
	public static var instance(default, null) = new Courier();
	var dispatcher : AsyncEventDispatcher;

	private function new() {
		dispatcher = new AsyncEventDispatcher<String>(Executor.create(2));
	}

	public static function 
}