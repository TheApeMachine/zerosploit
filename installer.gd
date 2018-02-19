extends Node

var root    = false
var console = false
var step    = 0
var itimer  = Timer.new()
var steps   = [
	'Downloading...',
	'Configuring...',
	'Compiling...',
	'Installed!'
]

func _ready():
	root    = get_parent()
	console = root.get_node('console')

func portscan():
	var price = 10
	
	if root == false:
		root    = get_parent()
		console = root.get_node('console')
	
	if root.money - price >= 0:
		console.echo("Installing portscan...")
		itimer.set_wait_time(1)
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
		step = 0
