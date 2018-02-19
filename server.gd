extends Spatial

var price       = 100
var ip          = [1, 0, 0, 0]
var connections = []
var delete_tag  = false
var console     = false

func _ready():
	randomize()

	ip = [
		randi() % 255 + 1,
		randi() % 255 + 1,
		randi() % 255 + 1,
		randi() % 255 + 1
	]
	
	var root = get_parent()
	console  = root.get_node('console')
	
	console.echo(str("server instantiated: ", ip))
	
func ping():
	return "pong"
	
func config():
	console.echo("Configuring server...")