extends Node

var host        = null
var player_info = {}
var my_info     = {
	name = "Bob"
}

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("server_disconnected", self, "_server_disconnect")
	
func start_server():
	host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_ZLIB)
	
	var err = host.create_server(33339, 10)
	
	if err != OK:
		print("Network address in use!")
		return
		
	get_tree().set_network_peer(host)
	print("Waiting for other players...")
	
func _player_connected(id):
	pass
	
func _player_disconnected(id):
	player_info.erase(id)
	
func _connected_ok():
	rpc("register_player", get_tree().get_network_unique_id(), my_info)
	
func _server_disconnected():
	pass
	
func _connected_fail():
	pass
	
remote func register_player(id, info):
	player_info[id] = info
	
	if get_tree().is_network_server():
		rpc_id(id, "register_player", 1, my_info)
		
		for peer_id in player_info:
			rpc_id(id, "register_player", peer_id, player_info[peer_id])
			
	