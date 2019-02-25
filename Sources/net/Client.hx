package net;

import hxbit.NetworkHost.NetworkClient;

class Client extends NetworkClient {
	var socket : Socket;

	public function new(host:Server, socket: Socket) {
		super(host);
		this.socket = socket;
	}
}