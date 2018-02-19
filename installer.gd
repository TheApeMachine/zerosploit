extends Node

var console = false

func _ready():
	var root = get_parent()
	console  = root.get_node('console')

func portscan():
	console.echo("Installing portscan...")