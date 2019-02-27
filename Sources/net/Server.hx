package net;

#if !js
import sys.net.UdpSocket;
import sys.net.Address;
import sys.net.Host;
import hx.concurrent.thread.Threads;
import haxe.io.Bytes;
import net.Client.ConnectionState;
#end

class Server {
	var socket : UdpSocket;
	var clients : Array<Client>;
	var maxClients = 20;
	var host : Host;
	var port : Int;
	var serializer : hxbit.Serializer;

	public function new() {
		socket = new UdpSocket();
		socket.setBlocking(false);
		clients = new Array<Client>();
		host = new Host('localhost');
		port = 9090;
		trace('starting server at '+'localhost:'+9090);
		socket.bind(host, port);
		Threads.spawn(listen);
	}

	function listen() {
		var data = Bytes.alloc(2048);
		var senderAddress = new Address();
		while (true) {
			socket.waitForRead();
			var len = socket.readFrom(data, 0, 2048, senderAddress); 
			switch (data.get(0)) {
				case Client.CONNECT:
					handleConnect(senderAddress);
				case Client.INPUT:
				case Client.MSG:
					trace(data.getString(1, 5));
			}
		}
	}

	function handleConnect(address) {
		trace('handleConnect');
		var index = findClientIndex(address);
		if (index > -1) {
			var client = clients[index];
			var b = Bytes.alloc(1);
			b.set(0, Client.ACCEPTED);
			client.send(b);
		} else if (clients.length >= maxClients) {
			var b = Bytes.alloc(1);
			b.set(0, Client.DENIED);
			socket.sendTo(b, 0, b.length, address);
		} else {
			var client = new Client(socket, address.getHost(), address.port, Connected);
			clients.push(client);
			var b = Bytes.alloc(1);
			b.set(0, Client.ACCEPTED);
			client.send(b);
			trace('new client connected: '+address.getHost().host+':'+address.port);
		}
	}

	function isClientConnected(address) {
		for (c in clients) {
			if (c.address.compare(address) == 0 && c.connectionState == Connected) {
				return true;
			}
		}
		return false;
	}

	function findClientIndex(address:Address) {
		for (i in 0...clients.length) {
			if (clients[i].connectionState == Connected && clients[i].address.compare(address) == 0) {
				return i;
			}
		}
		return -1;
	}

	public function sendState(stateUpdate:StateUpdate) {
		var b = serializer.serialize(stateUpdate);
		for (c in clients) {
			c.sendState(b);
		}
	}

	function close() {
		if (socket != null) {
			socket.close();
			socket = null;
		}
	}
}