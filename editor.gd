extends Node

func _ready():
	pass

func edit(content):
	var root    = get_parent()
	var console = root.get_node('console')
	
	console.text = ''
	console.echo(content)