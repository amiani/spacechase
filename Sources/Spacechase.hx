package;

import kha.Assets;
import kha.Framebuffer;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.KeyCode;

import box2D.dynamics.B2World;
import box2D.common.math.B2Vec2;
import tracks.Track;

import bodies.*;

class Spacechase {
  var TIMESTEP = 1/60;

  var waiting : Bool;
  var message : String = '';

  var width : Int;
  var height : Int;
  var scene : Node;
  var trackLayer : Node;
  var screen : Screen;
  var playerShip : Player;
  var asteroid : Asteroid;
  var background : Background;
  var world : B2World;
  var track : tracks.Track;
  var gate : Gate;

  public static var BGLAYER = 0;
  public static var TRACKLAYER = 1;
  public static var TRAILLAYER = 2;
  public static var BODYLAYER = 3;

  var time = 0.;

  public function new(width:Int, height:Int) {
    this.width = width;
    this.height = height;
    scene = new Node(null);
    trackLayer = new Node(scene);
    world = new B2World(new B2Vec2(0, 0), true);

    background = new Background(Assets.images.goldstartile, width, height);
    var playerStartPos = new B2Vec2(250,250);
    screen = new Screen(playerStartPos, width, height);
    playerShip = new Player(playerStartPos, scene, world);
    track = new Track(Assets.images.biglooptest, new B2Vec2(250, 250), trackLayer);
    asteroid = new Asteroid(new B2Vec2(260, 250), scene, world); 
    gate = new Gate(new B2Vec2(270, 250), scene, world);
  }
  
	public function update(): Void {
    world.step(TIMESTEP, 8, 3);
    world.clearForces();

    scene.update(TIMESTEP, worldToScreen);
    screen.update(TIMESTEP, playerShip.position, playerShip.velocity);

    /*
    if (time >= checkTime) {
      track.checkOnTrack(playerShip.sprite.getBounds(track.bitmap));
      checkTime += .5;
    }
    */
    track.update(TIMESTEP, worldToScreen);
	}

	public function draw(frames: Array<Framebuffer>): Void {
    var frameBuffer = frames[0];
    if (frameBuffer.width != width || frameBuffer.height != height) {
      width = frameBuffer.width;
      height = frameBuffer.height;
    }

    var g = frameBuffer.g2;
    g.begin();
    background.draw(g, width, height, worldToScreen);
    scene.draw(g);
    g.end();
	}

  inline function worldToScreen(position : B2Vec2) {
    return [
      (width / 2) - (screen.position.x - position.x)*64,
      (height / 2) - (position.y - screen.position.y)*64
    ];
  }
}
