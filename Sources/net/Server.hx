package net;

import sys.net.UdpSocket;
import sys.net.Address;
import sys.net.Host;
import hx.concurrent.thread.Threads;
import haxe.io.Bytes;

class Server {
	var socket : UdpSocket;
	var clients : Array<Client>;

	public function new() {
		socket = new UdpSocket();
		socket.setBlocking(false);
		clients = new Array<Client>();
		trace('starting server at '+'localhost:'+9090);
		socket.bind(new Host('localhost'), 9090);
		Threads.spawn(wait);
	}

	function wait() {
		var data = Bytes.alloc(10);
		var senderAddress = new Address();
		while (true) {
			socket.waitForRead();
			var len = socket.readFrom(data, 0, 10, senderAddress); 
			trace('len: '+ len);
			switch (data.get(0)) {
				case Client.MSG:
					trace(data.getString(1, 5));
				case Client.INPUT:

			}
		}
	}

	public function sendState(snapshots) {
		for (c in clients) {
			c.sendState(snapshots);
		}
	}

	function close() {
		if (socket != null) {
			socket.close();
			socket = null;
		}
	}
}