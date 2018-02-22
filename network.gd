extends Node

const DEFAULT_PORT = 10567
const MAX_PEERS    = 10

var player_name = 'server'
var players     = {}

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("server_disconnected", self, "_server_disconnect")
	
func start_server():
	player_name= 'Servie'
	
	var host = NetworkedMultiplayerENet.new()
	
	var err = host.create_server(DEFAULT_PORT, MAX_PEERS)
	
	if err != OK:
		print("NETWORK: Network address in use!")
		return
		
	get_tree().set_network_peer(host)
	print("NETWORK: Waiting for other players...")
	
func join_server():
	var host = NetworkedMultiplayerENet.new()
	host.create_client('127.0.0.1', DEFAULT_PORT)
	
	print("NETWORK: Connecting to server...")
	get_tree().set_network_peer(host)
	
func _player_connected(id):
	print("NETWORK: _player_connected(", id, ")")
	
func _player_disconnected(id):
	players.erase(id)
	
func _connected_ok():
	print("NETWORK: _connected_ok()")
	rpc("register_player", get_tree().get_network_unique_id(), player_name)
	
func _server_disconnected():
	pass
	
func _connected_fail():
	pass
	
remote func register_player(id, new_player_name):
	print("NETWORK: register_player(", id, ", ", new_player_name, ")")
	
	if get_tree().is_network_server():
		rpc_id(id, "register_player", 1, player_name)
		
		for p_id in players:
			rpc_id(id, "register_player", p_id, players[id])
			rpc_id(p_id, "register_player", id, new_player_name)
			
	players[id] = new_player_name
	rpc("initialize_game")
	
remote func initialize_game():
	print("NETWORK: initialize_game()")
	
	for p in players:
		print("NETWORK: initialize_game() - ", p)
		var player = preload("res://player.tscn").instance()
		player.set_name(str(p))
		
		get_parent().add_child(player)
	