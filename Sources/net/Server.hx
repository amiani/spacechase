package net;

import sys.net.UdpSocket;
import sys.net.Host;

class Server extends hxbit.NetworkHost {
	var socket : UdpSocket;

	function close() {
		if (socket != null) {
			socket.close();
			socket = null;
		}
	}

	public function connect(host:String, port:Int) {
		close();
		socket = new UdpSocket();
		self = new Client(this, socket);
		var host = new Host(host);
		socket.connect(host, port);
	}
}