extends TextEdit

var Http = load("res://http.tscn")

var list_timer = Timer.new()

func _ready():
	list_timer.set_wait_time(1)
	list_timer.connect("timeout", self, "_on_list_timer_timeout")
	add_child(list_timer)
	list_timer.start()
	var instance = Http.instance()
	self.add_child(instance)

func _on_list_timer_timeout():
	get_node("HTTPRequest").get("servers.json", self)

func handle_results(results):
	for server in results:
		var text = ""
		insert_text_at_cursor(str(server.ip, "\n"))

	