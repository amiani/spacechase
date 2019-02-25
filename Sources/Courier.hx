import hx.concurrent.executor.*;
import hx.concurrent.event.*;

class Courier {
	public static var instance(default, null) = new Courier();
	var dispatcher : AsyncDispatcher;

	private function new() {
		dispatcher = new AsyncDispatcher<String>(Executor.create(2));
	}
}