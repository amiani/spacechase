package net;

class Server extends hxbit.NetworkHost {
	var socket : Socket;

	function close() {
		if (socket != null) {
			socket.close();
			socket = null;
		}
	}

	public function connect(host:String, port:Int) {
		close();
		socket = new Socket();
		self = new Client(this, socket);
		socket.connect(host, port);
	}
}