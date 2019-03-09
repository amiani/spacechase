package;

import kha.Assets;

class Mainserver {
  static var spacechase : Spacechase;
	static var TIMESTEP = 1/60;

	public static function main() {
		Assets.loadEverything(() -> {
			// Just loading everything is ok for small projects
			spacechase = new Spacechase(1024, 768);
			var accumulator = 0.;
			var now = Sys.time()*1000;
			while (true) {
				var newTime = Sys.time()*1000;
				var frameTime = newTime - now;
				now = newTime;
				accumulator += frameTime;

				while (accumulator >= TIMESTEP) {
					spacechase.update();
					accumulator -= TIMESTEP;
				}
			}
		});
	}
}