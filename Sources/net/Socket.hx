package net;

import hx.concurrent.Thread;
import sys.net.UdpSocket;
import sys.net.Host;

class Socket {
	var s : UdpSocket;

	public function new() {
		s = new UdpSocket();
		s.setBlocking(false);
	}

	public function connect(host:String, port:Int) {
		var host = new Host(host);
		s.connect(host, port);
	}
}