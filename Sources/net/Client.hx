package net;

import control.KeyboardMouse;
#if !js
import sys.net.UdpSocket;
import sys.net.Host;
import sys.net.Address;
import hx.concurrent.thread.Threads;
import hx.concurrent.collection.Queue;
import hx.concurrent.collection.SynchronizedArray;
#end
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import control.Controller;
import control.Input;
import control.Remote;

enum ConnectionState {
	Disconnected;
	Connecting;
	Connected;
}

class Client {
	public static inline var CONNECT = 0;
	public static inline var ACCEPTED = 1;
	public static inline var DENIED = 2;
	public static inline var STATEUPDATE = 3;
	public static inline var INPUT = 4;
	public static inline var CONFIRMINPUT = 4;
	public static inline var MSG = 5;

	var socket : UdpSocket;
	var host : Host;
	public var connectionState(default, null) = Disconnected;
  public var latestNetFrame(default, null) = -1;
	public var latestInputFrame(default, null) = -1;
	public var lastConfirmedInputFrame(default, null) = -1;
	public var updateBuffer(default, null) : Queue<StateUpdate>;
	public var address(default, null) = new Address();
	var remote = new Remote();
	var connectTimer : haxe.Timer;
	var serializer = new hxbit.Serializer();

	public function new(socket:UdpSocket, host:Host, port:Int, ?connectionState:ConnectionState) {
		this.socket = socket;
		this.host = host;
		this.connectionState = connectionState == null ? Disconnected : connectionState;
		this.updateBuffer = new Queue<StateUpdate>();
		address.host = host.ip;
		address.port = port;
	}

	public inline function send(b) {
		socket.sendTo(b, 0, b.length, address);
	}

	#if net_client
	public function connect() {
		var b = Bytes.alloc(1);
		b.set(0, CONNECT);
		connectTimer = new haxe.Timer(250);
		connectTimer.run = ()->send(b);
		connectionState = Connecting;
		Threads.spawn(listen);
	}

	function listen() {
		var data = Bytes.alloc(2048);
		var senderAddress = new Address();
		while (true) {
			socket.waitForRead();
			var len = socket.readFrom(data, 0, 2048, senderAddress);
			var header = data.get(0);
			var payload = data.sub(1, len-1);
			switch (header) {
				case Client.ACCEPTED:
					handleAccepted(payload);
				case Client.DENIED:
					handleDenied();
				case Client.STATEUPDATE:
					handleState(payload);
				case Client.CONFIRMINPUT:
					handleConfirmInput(payload);
			}
		}
	}

	function handleAccepted(data:Bytes) {
		connectTimer.stop();
		if (connectionState != Connected) {
			trace('connected to server at: '+address.getHost().host+':'+address.port);
			connectionState = Connected;
			Spacechase.resetFrame(data.get(0));
		}
	}
	
	function handleDenied() {
		connectTimer.stop();
		if (connectionState != Disconnected) {
			trace('server full');
			connectionState = Disconnected;
		}
	}
	
	function handleState(data:Bytes) {
		//trace('handleState');
		var stateUpdate = serializer.unserialize(data, StateUpdate);
		if (stateUpdate.frame > latestNetFrame) {
			updateBuffer.push(stateUpdate);
			latestNetFrame = stateUpdate.frame;
		}
	}

	public function sendInput(input:InputArray) {
		if (connectionState == Connected) {
			//var c = new Controller();
			//c.inputHistory = input.inputHistory;
			var inputBytes = serializer.serialize(input);
			var buf = new BytesBuffer();
			buf.addByte(INPUT);
			buf.add(inputBytes);
			var out = buf.getBytes();
			trace(out.length);
			send(out);
		}
	}

	public function handleConfirmInput(data:Bytes) {
		trace('confirm input');
		var frame = data.get(0);
		trace('frame: '+frame);
		lastConfirmedInputFrame = frame;
	}
	#end
	
	public function sendMessage(msg:String) {
		var buf = new BytesBuffer();
		buf.addByte(MSG);
		buf.addString(msg);
		var out = buf.getBytes();
		trace('string length: '+out.length);
		send(out);
	}

	public function sendState(stateUpdate:StateUpdate) {
		var stateBytes = serializer.serialize(stateUpdate);
		var buf = new BytesBuffer();
		buf.addByte(STATEUPDATE);
		buf.add(stateBytes);
		var out = buf.getBytes();
		send(out);
	}

	public function addInputs(inputs:Array<Input>) {
		if (inputs.length > 0)
			remote.addInputs(inputs);

		var b = Bytes.alloc(2);
		b.set(0, CONFIRMINPUT);
		b.set(1, inputs[inputs.length-1].frame);
		send(b);
	}
}