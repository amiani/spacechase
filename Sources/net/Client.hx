package net;

enum ClientState {
	Disconnected;
	Connecting;
	Connected;
}

import sys.net.UdpSocket;
import sys.net.Host;
import sys.net.Address;
import haxe.io.BytesBuffer;
import hx.concurrent.thread.Threads;

class Client {
	static inline var UPDATE = 0;
	static inline var INPUT = 1;
	static inline var MSG = 2;
	var state = ClientState.Disconnected;
	var socket : UdpSocket;
	var address = new Address();
	var host : Host;

	public function new(socket:UdpSocket, host:Host, port:Int) {
		this.socket = socket;
		this.host = host;
		address.host = host.ip;
		address.port = port;
		connect();
	}

	function connect() {

	}

	public function sendMessage(msg:String) {
		var buf = new BytesBuffer();
		buf.addByte(MSG);
		buf.addString(msg);
		var out = buf.getBytes();
		trace('string length: '+out.length);
		socket.sendTo(out, 0, out.length, address);
	}

	public function sendInput(input) {
		var buf = new BytesBuffer();
		buf.addByte(INPUT);
		buf.add(input);
		var out = buf.getBytes();
		socket.sendTo(out, 0, out.length, address);
	}
	
	public function sendState(snapshots) {
		var buf = new BytesBuffer();
		buf.addByte(UPDATE);
		buf.add(snapshots);
		var out = buf.getBytes();
		socket.sendTo(out, 0, out.length, address);
	}
}