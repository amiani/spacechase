package;

import kha.Assets;
import kha.Scheduler;
import kha.System;

class Main {
	static inline var width = 1024;
	static inline var height = 768;
  static var spacechase : Spacechase;

	public static function main() {
		System.start({title: "Chase in Space", width: width, height: height}, function (_) {
			// Just loading everything is ok for small projects
			Assets.loadEverything(function () {
				spacechase = new Spacechase(width, height);
				// Avoid passing update/render directly,
				// so replacing them via code injection works
				Scheduler.addTimeTask(function () { spacechase.update(); }, 0, 1 / 60);
				System.notifyOnFrames(function (frames) { spacechase.draw(frames); });
			});
		});
	}
}
