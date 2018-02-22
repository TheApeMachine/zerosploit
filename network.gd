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
		print("NETWORK: Network address in use!")
		return
		
	get_tree().set_network_peer(host)
	initialize_game()
	
	print("NETWORK: Waiting for other players...")
	
func join_server():
	host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_ZLIB)
	host.create_client('127.0.0.1', 33339)
	get_tree().set_network_peer(host)
	print("NETWORK: Connecting to server...")
	
func _player_connected(id):
	print("NETWORK: _player_connected(", id, ")")
	
func _player_disconnected(id):
	player_info.erase(id)
	
func _connected_ok():
	print("NETWORK: _connected_ok()")
	rpc("register_player", get_tree().get_network_unique_id(), my_info)
	
func _server_disconnected():
	pass
	
func _connected_fail():
	pass
	
remote func register_player(id, info):
	print("NETWORK: register_player(", id, ", ", info, ")")
	player_info[id] = info
	
	if get_tree().is_network_server():
		rpc_id(id, "register_player", 1, my_info)
		
		for peer_id in player_info:
			rpc_id(id, "register_player", peer_id, player_info[peer_id])
			
remote func initialize_game():
	var self_peer_id = get_tree().get_network_unique_id()
	var my_player    = preload("res://player.tscn").instance()
	
	my_player.set_name(str(self_peer_id))
	my_player.set_network_master(self_peer_id)
	get_parent().add_child(my_player)
	
	for p in player_info:
		var player = preload("res://player.tscn").instance()
		player.set_name(str(p))
		get_parent().add_child(player)
	