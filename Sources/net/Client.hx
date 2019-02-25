package net;

import sys.net.UdpSocket;
import hxbit.NetworkHost.NetworkClient;

class Client extends NetworkClient {
	var socket : UdpSocket;

	public function new(host:Server, socket: UdpSocket) {
		super(host);
		this.socket = socket;

	}
}