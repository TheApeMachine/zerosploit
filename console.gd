extends TextEdit

var cmd      = ""
var pbuf     = false
var tokens   = []
var AST      = []
var keywords = [
	'QUIT',
	'BUILD',
	'PROGRAM',
	'END PROGRAM'
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
	var lex = ""
	
	for i in input:
		lex += i
		
		if lex in keywords:
			if lex == 'PROGRAM':
				pbuf = true
			elif lex == 'END PROGRAM':
				pbuf = false
			else:
				tokens.append({'id': 'keyword', 'value': lex})
	
	if pbuf == false:
		parser()
	
func parser():
	print("TOKENS: ", tokens)
	
	# TODO: Build actual AST
	
	for token in tokens:
		if token['id'] == 'keyword':
			AST.append(token['value'])
			
	run()

func add_ast_node(parent, node):
	for a in AST:
		if parent in a:
			a[parent].append(node)

func run(ast=AST):
	print("AST: ", ast)
	
	for a in ast:
		if typeof(a) == TYPE_DICTIONARY:
			pass
		elif typeof(a) == TYPE_ARRAY:
			pass
		else:
			call(a.to_lower())
	
	tokens = []
	AST    = []

func build():
	var server   = load('res://server.tscn')
	var instance = server.instance()
	
	instance.set_translation(Vector3(10, 1, 5))
	get_node(".").call_deferred('add_child', instance)
	
	print('Built a server!')

func quit():
	get_tree().quit()
