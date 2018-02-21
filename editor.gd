extends Node

func _ready():
	pass
	
func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		ask_save()
	
func edit(content):
	var root    = get_parent()
	var console = root.get_node('console')
	
	console.text = ''
	console.echo(content)
	
	console.add_keyword_color('build', Color(255, 0, 0))

	console.caret_blink         = true
	console.show_line_numbers   = true
	console.syntax_highlighting = true
	
func ask_save():
	var root    = get_parent()
	var console = root.get_node('console')
	
	console.insert_text_at_cursor("\nSave this file? (Y/n): ")