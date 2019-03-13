package net;

#if !js
import sys.net.UdpSocket;
import sys.net.Address;
import sys.net.Host;
import hx.concurrent.thread.Threads;
import haxe.io.Bytes;
import net.Client.ConnectionState;
#end
import control.Controller;
import control.KeyboardMouse;

class Server {
	var serializer = new hxbit.Serializer();
	var clients : Array<Client>;
	var host : Host;
	var port : Int;
	var socket : UdpSocket;
	var maxClients = 20;
	var resetScene : Int -> Void;

	public function new(resetScene) {
		this.resetScene = resetScene;
		clients = new Array<Client>();
		host = new Host('0.0.0.0');
		port = 9090;
		socket = new UdpSocket();
		socket.setBlocking(false);
		socket.bind(host, port);
		trace('starting server at '+9090);
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
					trace(len);
					handleInput(data.sub(1, len-1), senderAddress);
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
			b.set(1, Spacechase.frame);
			client.send(b);
		} else if (clients.length >= maxClients) {
			var b = Bytes.alloc(1);
			b.set(0, Client.DENIED);
			socket.sendTo(b, 0, b.length, address);
		} else {
			var client = new Client(socket, address.getHost(), address.port, resetScene, Connected);
			clients.push(client);
			trace('here1');
			resetScene(0);
			trace('here2');
			var b = Bytes.alloc(1);
			b.set(0, Client.ACCEPTED);
			b.set(1, Spacechase.frame);
			client.send(b);
			trace('new client connected: '+address.getHost().host+':'+address.port);
		}
	}

	function handleInput(data:Bytes, address:Address) {
		var client = findClient(address);
		var inputs = serializer.unserialize(data, InputArray).inputs;
		client.addInputs(inputs);
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

	function findClient(address:Address) {
		for (client in clients) {
			if (client.address.compare(address) == 0 && client.connectionState == Connected)
				return client;
		}
		return null;
	}

	public function sendState(stateUpdate:StateUpdate) {
		for (c in clients) {
			c.sendState(stateUpdate);
		}
	}

	function close() {
		if (socket != null) {
			socket.close();
			socket = null;
		}
	}
}