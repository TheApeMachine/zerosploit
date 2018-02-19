extends Node

var root    = false
var console = false
var steps   = []
var step    = 0
var itimer  = Timer.new()

func _ready():
	root     = get_parent()
	console  = root.get_node('console')

func portscan():
	var price = 10
	steps     = [
		'Installing portscan...',
		'Downloading...',
		'Configuring...',
		'Compiling...',
		'Installed!'
	]
	
	if root.money - price >= 0:
		itimer.set_wait_time(3)
		itimer.connect("timeout", self, "_on_install_timeout")
		add_child(itimer)
		itimer.start()
	else:
		console.echo("Insufficient funds...")
		
func _on_install_timeout():
	if step < len(steps):
		console.echo(steps[step])
		step += 1
	else:
		itimer.stop()
