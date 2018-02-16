extends TextEdit

var cmd      = ""
var keywords = [
	'QUIT',
	'BUILD'
]

func _ready():
	insert_text_at_cursor(">")
	
func _input(event):
	if Input.is_key_pressed(KEY_ENTER):
		lexer(cmd.to_upper())
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
	var tokens = []
	var lex    = ""
	
	for i in input:
		lex += i
		
		if lex in keywords:
			tokens.append({'id': 'keyword', 'value': lex})
			
	parser(tokens)
	
func parser(tokens):
	print(tokens)
	var AST = []
	
	for token in tokens:
		if token['id'] == 'keyword':
			execute(token['value'])
			
func execute(keyword):
	call(keyword.to_lower())

func build():
	var server   = load('res://server.tscn')
	var instance = server.instance()
	
	instance.set_translation(Vector3(10, 1, 5))
	get_node(".").call_deferred('add_child', instance)
	
	print('Built a server!')

func quit():
	get_tree().quit()
