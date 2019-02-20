package;

import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import box2D.dynamics.B2World;
import box2D.common.math.B2Vec2;

import bodies.*;

class Main {
  static var TIMESTEP = 1/60;
  static var accumulator = 0.;

	static inline var width = 1024;
	static inline var height = 768;

  var scene : Node;
  var screen : Screen;
  var playerShip : Player;
  var asteroid : Asteroid;
  //var background : h2d.Bitmap;
  var world : B2World;
  var track : tracks.Track;
  var gate : Gate;

  public static var BGLAYER = 0;
  public static var TRACKLAYER = 1;
  public static var TRAILLAYER = 2;
  public static var BODYLAYER = 3;

  var time = 0.;

	function init() {
    scene = new Node(null);
    world = new B2World(new B2Vec2(0, 0), true);

    var playerStartPos = new B2Vec2(250,250);
    playerShip = new Player(playerStartPos, scene, world);
    asteroid = new Asteroid(new B2Vec2(260, 250), scene, world); 
    gate = new Gate(new B2Vec2(270, 250), scene, world);

    playerShip.parent = scene;
    asteroid.parent = scene;
    gate.parent = scene;

    /*
    screen = new Screen(playerStartPos, s2d.width, s2d.height);

    var starTile = hxd.Res.goldstartile.toTile();
    starTile.setSize(Std.int(Math.pow(starTile.width, 2)), Std.int(Math.pow(starTile.height, 2)));
    background = new h2d.Bitmap(starTile.center());
    background.tileWrap = true;
    s2d.add(background, BGLAYER);

    track = new tracks.Track(hxd.Res.testtrack, new B2Vec2(250, 250));
    s2d.add(track.bitmap, TRACKLAYER);
    */
	}

  var checkTime = 0.;
	static function update(): Void {
    world.step(TIMESTEP, 8, 3);
    world.clearForces();
    scene.update(TIMESTEP);

    /*
    screen.update(TIMESTEP, playerShip.position, playerShip.velocity);
    if (time >= checkTime) {
      track.checkOnTrack(playerShip.sprite.getBounds(track.bitmap));
      checkTime += .5;
    }
    track.update(TIMESTEP, worldToScreen);

    var backgroundPos = worldToScreen(new B2Vec2(250,250));
    background.setPosition(backgroundPos[0], backgroundPos[1]);
    */
	}

	static function render(frames: Array<Framebuffer>): Void {

	}

	public static function main() {
		System.start({title: "Project", width: width, height: height}, function (_) {
			// Just loading everything is ok for small projects
			Assets.loadEverything(function () {
				init();
				// Avoid passing update/render directly,
				// so replacing them via code injection works
				Scheduler.addTimeTask(function () { update(); }, 0, TIMESTEP);
				System.notifyOnFrames(function (frames) { render(frames); });
			});
		});
	}
	
  inline function worldToScreen(position : B2Vec2) {
    return [
      (width / 2) - (screen.position.x - position.x)*64,
      (height / 2) - (position.y - screen.position.y)*64
    ];
  }
}
