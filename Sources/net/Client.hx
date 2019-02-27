package net;

#if !js
import sys.net.UdpSocket;
import sys.net.Host;
import sys.net.Address;
import hx.concurrent.thread.Threads;
#end
import haxe.io.Bytes;
import haxe.io.BytesBuffer;

enum ConnectionState {
	Disconnected;
	Connecting;
	Connected;
}

class Client {
	public static inline var CONNECT = 0;
	public static inline var ACCEPTED = 1;
	public static inline var DENIED = 2;
	public static inline var STATE = 3;
	public static inline var INPUT = 4;
	public static inline var MSG = 5;
	public var connectionState(default, null) = Disconnected;
	var socket : UdpSocket;
	public var address(default, null) = new Address();
	var host : Host;
	var connectTimer : haxe.Timer;

	public function new(socket:UdpSocket, host:Host, port:Int, ?connectionState:ConnectionState) {
		this.socket = socket;
		this.host = host;
		this.connectionState = connectionState == null ? Disconnected : connectionState;
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
			switch (data.get(0)) {
				case Client.ACCEPTED:
					handleAccepted();
				case Client.DENIED:
					handleDenied();
				case Client.STATE:
					handleState(data.sub(1, len-1));
			}
		}
	}

	function handleAccepted() {
		connectTimer.stop();
		if (connectionState != Connected) {
			trace('connected to server at: '+address.getHost().host+':'+address.port);
			connectionState = Connected;
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

	}

	public function sendInput(input) {
		var buf = new BytesBuffer();
		buf.addByte(INPUT);
		buf.add(input);
		var out = buf.getBytes();
		send(out);
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

	public function sendState(snapshots) {
		var buf = new BytesBuffer();
		buf.addByte(STATE);
		buf.add(snapshots);
		var out = buf.getBytes();
		send(out);
	}
}