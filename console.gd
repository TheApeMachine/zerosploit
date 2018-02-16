extends TextEdit

var tokens = {}
var AST    = []
var cmd    = ""

func _ready():
	insert_text_at_cursor(">")
	
func _input(event):
	if Input.is_key_pressed(KEY_ENTER):
		lexer(cmd)
		cmd = ""
		insert_text_at_cursor(">")
	elif !event.is_pressed() and !event.is_class("InputEventMouseMotion"):
		var e = event.as_text()
		
		if e == 'Space':
			cmd += ' '
		elif e == 'BackSpace':
			cmd = cmd.left(len(cmd) - 1)
		else:
			cmd += event.as_text()

func lexer(input):
	print(input)
	
func parser():
	pass
