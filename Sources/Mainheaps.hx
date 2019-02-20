import h2d.Graphics;
import box2D.dynamics.B2World;
import box2D.common.math.B2Vec2;
import bodies.*;

class Main extends hxd.App {
  var TIMESTEP = 1/60;
  var accumulator = 0.;

  var screen : Screen;
  var playerShip : Player;
  var asteroid : Asteroid;
  var background : h2d.Bitmap;
  var world : B2World;
  var track : tracks.Track;
  var gate : Gate;
  var bodies : Array<Body>;

  static public var BGLAYER = 0;
  static public var TRACKLAYER = 1;
  static public var TRAILLAYER = 2;
  static public var BODYLAYER = 3;

  var time = 0.;

  override function init() {
    bodies = new Array<Body>();
    world = new B2World(new B2Vec2(0, 0), true);

    var playerStartPos = new B2Vec2(250,250);
    playerShip = new Player(playerStartPos, s2d, world);
    asteroid = new Asteroid(new B2Vec2(260, 250), s2d, world); 
    gate = new Gate(new B2Vec2(270, 250), s2d, world);

    bodies.push(playerShip);
    bodies.push(asteroid);
    bodies.push(gate);

    screen = new Screen(playerStartPos, s2d.width, s2d.height);

    var starTile = hxd.Res.goldstartile.toTile();
    starTile.setSize(Std.int(Math.pow(starTile.width, 2)), Std.int(Math.pow(starTile.height, 2)));
    background = new h2d.Bitmap(starTile.center());
    background.tileWrap = true;
    s2d.add(background, BGLAYER);

    track = new tracks.Track(hxd.Res.testtrack, new B2Vec2(250, 250));
    s2d.add(track.bitmap, TRACKLAYER);
  }
  

  static function main() {
    hxd.Res.initEmbed();
    new Main();
  }

  var checkTime = 0.;
  override function update(dt: Float) {
    accumulator += dt;
    while (accumulator >= TIMESTEP) {
      time += TIMESTEP;

      for (b in bodies) b.update(TIMESTEP, worldToScreen);

      world.step(TIMESTEP, 8, 3);
      world.clearForces();

      screen.update(TIMESTEP, playerShip.position, playerShip.velocity);
      if (time >= checkTime) {
        track.checkOnTrack(playerShip.sprite.getBounds(track.bitmap));
        checkTime += .5;
      }
      track.update(TIMESTEP, worldToScreen);

      var backgroundPos = worldToScreen(new B2Vec2(250,250));
      background.setPosition(backgroundPos[0], backgroundPos[1]);

      accumulator -= TIMESTEP;
    }
  }

  override function onResize() {
    screen.onResize(s2d.width, s2d.height);
  }

  inline function worldToScreen(position : B2Vec2) {
    return [
      (s2d.width / 2) - (screen.position.x - position.x)*64,
      (s2d.height / 2) - (position.y - screen.position.y)*64
    ];
  }
}