extends Node

var f_name   = ""
var saving   = false
var save_buf = ""

func _ready():
	pass
	
func _input(event):
	if saving == false:
		if Input.is_key_pressed(KEY_ESCAPE):
			ask_save()
	else:
		if Input.is_key_pressed(KEY_Y):
			save_file()
	
func edit(content, fname):
	var root    = get_parent()
	var console = root.get_node('console')
	f_name      = fname
		
	for keyword in console.keywords:
		console.add_keyword_color(keyword.to_lower(), Color(0, 255, 0))
		
	console.caret_blink         = true
	console.show_line_numbers   = true
	console.syntax_highlighting = true
	console.text                = content
	
func ask_save():
	var root    = get_parent()
	var console = root.get_node('console')
	save_buf    = console.text
	saving      = true
	
	console.insert_text_at_cursor("\nSave this file? (Y/n): ")
	
func save_file():
	var root     = get_parent()
	var console  = root.get_node('console')
	var file     = File.new()
	console.text = ''
	
	file.open(str('res://filesystem/', f_name.replace('period', '.')), file.WRITE)
	file.store_string(save_buf)
	file.close()
	