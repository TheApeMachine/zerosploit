extends TextEdit

var cmd      = ""
var lex      = ""
var pbuf     = false
var tokens   = []
var AST      = []
var keywords = [
	'QUIT',
	'BUILD',
	'PROGRAM',
	'END PROGRAM',
	'SCAN',
	'ECHO'
]

func _ready():
	insert_text_at_cursor(">")
	
func _input(event):
	if Input.is_key_pressed(KEY_ENTER):
		get_tree().set_input_as_handled()
		insert_text_at_cursor("\n>")
		lexer(cmd.to_upper())
		cmd = ""
	elif !event.is_pressed() and !event.is_class("InputEventMouseMotion"):
		var e = event.as_text()
		
		if e == 'Space':
			cmd += ' '
		elif e == 'BackSpace':
			cmd = cmd.left(len(cmd) - 1)
		elif e == 'Enter':
			pass
		else:
			cmd += event.as_text()

func lexer(input):
	lex = ""
	
	for i in input:
		lex += i
		print(lex)
		
		if lex in keywords:
			if lex == 'PROGRAM':
				pbuf = true
				print("Program buffer started...")
			elif lex == 'END PROGRAM':
				pbuf = false
				print("Program buffer ended.")
			else:
				tokens.append({'id': 'keyword', 'value': lex})
	
	if pbuf == false:
		parser()
	
func parser():
	print("TOKENS: ", tokens)
	
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
	
func echo(string):
	insert_text_at_cursor(str("\n", string, "\n"))

func build():
	var root     = get_parent()
	var server   = load('res://server.tscn')
	var instance = server.instance()
	
	if root.money - instance.price >= 0:
		instance.set_translation(Vector3(10, 1, 5))
		root.call_deferred('add_child', instance)
	
		root.players.append(instance)
	
		print('Built a server!')
	else:
		echo("insufficient funds!")
	
func scan():
	var root 	= get_parent()
	var players = root.players
	
	for p in players:
		print(p.ping(), ' from ', PoolStringArray(p.ip).join('.'))

func quit():
	get_tree().quit()
