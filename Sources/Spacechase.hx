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

#if (net_client && !js)
import sys.net.Host;
import sys.net.UdpSocket;
import hx.concurrent.collection.Queue;
#end

class Spacechase {
  var TIMESTEP = 1/60;

  var waiting : Bool;
  var message : String = '';

  var width : Int;
  var height : Int;
  var trackLayer : Node;
  var screen : Screen;
  var playerShip : Player;
  var asteroid : Asteroid;
  var background : Background;
  var world : B2World;
  var track : tracks.Track;
  var gate : Gate;

  #if !js
  #if net_server
  var server = new net.Server();
  #end
  #if net_client
  var client : net.Client;
  var updateBuffer : Queue<net.StateUpdate>;
  #end
  #end

  public static var BGLAYER = 0;
  public static var TRACKLAYER = 1;
  public static var TRAILLAYER = 2;
  public static var BODYLAYER = 3;

  public static var scene = new Scene();
  var frame = 0;

  public function new(width:Int, height:Int) {
    this.width = width;
    this.height = height;
    trackLayer = new Node(scene);
    world = new B2World(new B2Vec2(0, 0), true);

    background = new Background(Assets.images.goldstartile, width, height);
    var playerStartPos = new B2Vec2(250,250);
    screen = new Screen(playerStartPos, width, height);
    playerShip = new Player(playerStartPos, scene, world);
    track = new Track(Assets.images.biglooptest, new B2Vec2(250, 250), trackLayer);
    asteroid = new Asteroid(new B2Vec2(260, 250), scene, world); 
    gate = new Gate(new B2Vec2(270, 250), scene, world);

    #if (!js && net_client)
    var socket = new UdpSocket();
    socket.setBlocking(false);
    client = new net.Client(socket, new Host('localhost'), 9090);
    client.connect();
    #end
    trace('made spacechase');
  }
  
	public function update(): Void {
    trace('update');
    #if (!js && net_client)
    var stateUpdate = client.updateBuffer.pop();
    if (stateUpdate != null) scene.applyStateUpdate(stateUpdate);
    #end
    scene.update(TIMESTEP, worldToScreen);
    screen.update(TIMESTEP, playerShip.position, playerShip.velocity);

    world.step(TIMESTEP, 8, 3);
    world.clearForces();
    /*
    if (time >= checkTime) {
      track.checkOnTrack(playerShip.sprite.getBounds(track.bitmap));
      checkTime += .5;
    }
    */
    track.update(TIMESTEP, worldToScreen);

    #if net_server
    server.sendState(scene.getStateUpdate(frame));
    #end
    frame++;
    trace('ended update');
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
