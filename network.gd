extends Node

var player_info = {}
var my_info     = {
	name      = "Test Player",
	fav_color = Color8(255, 0, 255)
}

func _ready():
	print("Setting up network")
	var tree = get_tree()
	
	tree.connect("network_peer_connected", self, "_player_connected")
	tree.connect("network_peer_disconnected", self, "_player_disconnected")
	tree.connect("connected_to_server", self, "_connected_ok")
	tree.connect("connection_failed", self, "_connected_fail")
	tree.connect("server_disconnected", self, "_server_disconnected")
	
func _player_connected(id):
	pass
	
func _player_disconnected(id):
	player_info.erase(id)
	
func _connected_ok():
	rpc("register_player", get_tree().get_network_unique_id(), my_info)
	
func _connected_fail():
	pass
	
remote func register_player(id, info):
	player_info[id] = info
	
	if get_tree().is_network_server():
		rpc_id(id, "register_player", 1, my_info)
		
		for peer_id in player_info:
			rpc_id(id, "register_player", peer_id, player_info[peer_id])