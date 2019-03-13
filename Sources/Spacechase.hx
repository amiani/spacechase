package;

import control.Controller;
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

enum GameState {
  Stopped;
  Paused;
  Running;
}

class Spacechase {
  var gameState = Stopped;
  var TIMESTEP = 1/60;

  var waiting : Bool;
  var message : String = '';

  var width : Int;
  var height : Int;
  var trackLayer : Node;
  var screen : Screen;
  var screenTarget : Node;
  var playerStartPos = new B2Vec2(250,250);
  var playerShip : Player;
  var asteroid : Asteroid;
  var background : Background;
  var keyboardMouse : control.KeyboardMouse;
  var world : B2World;
  var track : tracks.Track;
  var gate : Gate;

  #if !js
  #if net_server
  var server : net.Server;
  #end
  #if net_client
  var client : net.Client;
  #end
  #end

  public static var BGLAYER = 0;
  public static var TRACKLAYER = 1;
  public static var TRAILLAYER = 2;
  public static var BODYLAYER = 3;

  var menu : Menu;
  var scene : Scene;
  public static var activeScene(default, null) : Scene;
  public static var frame(default, null) = 0;

  public function new(width:Int, height:Int) {
    this.width = width;
    this.height = height;
    scene = new Scene();
    activeScene = scene;
    background = new Background(Assets.images.goldstartile, width, height);
    world = new B2World(new B2Vec2(0, 0), true);
    screen = new Screen(width, height);
    screenTarget = new Node(null);
    screenTarget.linearVelocity = new B2Vec2(0, 0);
    screenTarget.position = new B2Vec2(250, 250);

    menu = new Menu(resetScene, connect);
    keyboardMouse = new control.KeyboardMouse();

    #if !js
    #if net_server
    server = new net.Server(resetScene);
    #end
    #if net_client
    var socket = new UdpSocket();
    socket.setBlocking(false);
    var args = Sys.args();
    var host = new Host('192.168.0.103');
    var port = 9090;
    if (args.length == 2) {
      host = new Host(args[0]);
      port = Std.parseInt(args[1]);
    }
    client = new net.Client(socket, host, port, resetScene);
    #end
    #else
    #end
  }
  
	public function update(): Void {
    #if (!js && net_client)
    if (client.updateBuffer.length > 0) {
      var stateUpdate = client.updateBuffer.pop();
      scene.applyStateUpdate(stateUpdate);
    }
    keyboardMouse.update(TIMESTEP, frame, client.lastConfirmedInputFrame);
    #end
    
    scene.update(TIMESTEP);
    world.step(TIMESTEP, 8, 3);
    world.clearForces();
    /*
    if (time >= checkTime) {
      track.checkOnTrack(playerShip.sprite.getBounds(track.bitmap));
      checkTime += .5;
    }
    */
    //track.update(TIMESTEP);

    #if !net_server
    screen.update(TIMESTEP, screenTarget.position, screenTarget.linearVelocity);
    #end
    #if !js
    if (gameState == Running) {
      #if net_client
      client.sendInput(keyboardMouse.getInputArray());
      #end
      #if net_server
      server.sendState(scene.getStateUpdate(frame));
      #end
    }
    #end
    frame++;
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
    scene.draw(g, worldToScreen);
    menu.draw(g, width, height);
    g.end();
	}

  inline function worldToScreen(position : B2Vec2):Vec2 {
    return {
      x: (width / 2) - (screen.position.x - position.x)*64,
      y: (height / 2) - (position.y - screen.position.y)*64
    };
  }

  function resetScene(frame:Int) {
    playerShip = new Player(playerStartPos, scene, world, keyboardMouse);
    screenTarget = playerShip;
    trackLayer = new Node(scene);
    track = new Track(Assets.images.biglooptest, new B2Vec2(250, 250), trackLayer);
    asteroid = new Asteroid(new B2Vec2(260, 251), scene, world); 
    asteroid = new Asteroid(new B2Vec2(260, 252), scene, world); 
    asteroid = new Asteroid(new B2Vec2(260, 253), scene, world); 
    asteroid = new Asteroid(new B2Vec2(261, 250), scene, world); 
    asteroid = new Asteroid(new B2Vec2(262, 250), scene, world); 
    gate = new Gate(new B2Vec2(270, 250), scene, world);
    Spacechase.frame = frame;
    gameState = Running;
  }

  function connect() {
    #if (!js && net_client)
    client.connect();
    #end
  }
}
