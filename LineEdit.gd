extends LineEdit

var Http = load("res://http.tscn")

func _ready():
	var http = get_node("../../../HTTPRequest")
	http.request("http://zerosploit-api.herokuapp.com/ips.json")
	var instance = Http.instance()
	self.add_child(instance)
	get_node("../LineEdit/HTTPRequest").get("servers.json", self)

func handle_results(results):
	for server in results:
		self.text = server.ip
