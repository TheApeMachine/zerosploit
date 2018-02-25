extends Node

const DEFAULT_PORT = 10567
const MAX_PEERS    = 10
var   players      = {}

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("server_disconnected", self, "_server_disconnect")
	
func start_server():
	var host    = NetworkedMultiplayerENet.new()
	var err     = host.create_server(DEFAULT_PORT, MAX_PEERS)
	
	if err != OK:
		print("NETWORK: Network address in use!")
		join_server()
		return
		
	get_tree().set_network_peer(host)
	
	var player     = preload("res://player.tscn").instance()
	player.control = true
	players["1"]   = player
	
	player.set_name("1")
	call_deferred('add_child', player)
	
	print("NETWORK: Waiting for other players...")
	
func join_server():
	var host = NetworkedMultiplayerENet.new()
	host.create_client('127.0.0.1', DEFAULT_PORT)
	
	print("NETWORK: Connecting to server...")
	get_tree().set_network_peer(host)
	
func _player_connected(id):
	print("NETWORK: _player_connected(", id, ")")
	
func _player_disconnected(id):
	var root = get_parent()
	root.players.erase(id)
	
func _connected_ok():
	print("NETWORK: _connected_ok()")
	rpc("register_player", get_tree().get_network_unique_id())
	
func _server_disconnected():
	pass
	
func _connected_fail():
	pass
	
remote func register_player(id):
	print("NETWORK: register_player(", id, ")")
	
	if get_tree().is_network_server():
		pass
	else:
		pass
		
	var root = get_parent()
	
	for player in root.players:
		var p = preload("res://player.tscn").instance()
		
		p.set_name(str(id))
		root.add_child(p)
	