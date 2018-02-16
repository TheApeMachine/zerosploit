extends TextEdit

var current_line = 1
var tokens = {}
var AST    = []

func _ready():
	insert_text_at_cursor(">")
	
func _input(event):
	if Input.is_key_pressed(KEY_ENTER):
		insert_text_at_cursor("\n")
		current_line += 1
		cursor_set_line(current_line)
		insert_text_at_cursor(">")
		cursor_set_column(2)
		
func lexer():
	pass
	
func parser():
	pass
