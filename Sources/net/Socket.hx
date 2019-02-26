package net;

import hx.concurrent.thread.Threads;
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
		try {
			s.connect(host, port);
			Threads.spawn(attend);
		} catch(e:Dynamic) {
			trace("couldn't connect!");
		}
	}
	
	function attend() {
		while (true) {
			s.waitForRead();
			s.read();
		}
	}
	
	public function close() {
		s.close();
	}
}