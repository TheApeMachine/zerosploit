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
	'ECHO',
	'CONFIG',
	'INSTALL',
	'LIST',
	'EDIT'
]

func _ready():
	var init = load_file('console.rc').split("\n")
	
	for i in init:
		lexer(i.to_upper() + "\n")
	
	insert_text_at_cursor(">")
	
func _input(event):
	if Input.is_key_pressed(KEY_ENTER):
		cmd += "\n"
		get_tree().set_input_as_handled()
		insert_text_at_cursor(">")
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

	for words in input.split(' '):
		for i in words:
			lex += i
			print(lex)
			
			if lex in keywords:
				if lex == 'PROGRAM':
					pbuf = true
					lex  = ""
					print("Program buffer started...")
				elif lex == 'END PROGRAM':
					pbuf = false
					lex  = ""
					print("Program buffer ended.")
				else:
					tokens.append({'id': 'keyword', 'value': lex})
					lex = ""
			else:
				if lex.right(len(lex) - 1) == "\n":
					tokens.append({'id': 'argument', 'value': lex.left(len(lex) - 1)})
					lex = ""
	
	if pbuf == false:
		parser()
	
func parser():
	print("TOKENS: ", tokens)
	
	var cur_node = ""
	
	for token in tokens:
		if token['id'] == 'keyword':
			var val  = token['value']
			cur_node = val
			
			AST.append({val: []})
		elif token['id'] == 'argument':
			add_ast_node(cur_node, token['value'])
		
	run()

func add_ast_node(parent, node):
	for a in AST:
		if parent in a:
			a[parent].append(node)

func run(ast=AST):
	print("AST: ", ast)
	
	for a in ast:
		if typeof(a) == TYPE_DICTIONARY:
			for k in a:
				call(k.to_lower(), PoolStringArray(a[k]).join(', ').to_lower())
		elif typeof(a) == TYPE_ARRAY:
			print("DEBUG AST ARRAY: ", a)
		else:
			call(a.to_lower())
	
	tokens = []
	AST    = []
	
func echo(string):
	insert_text_at_cursor(str("\n", string, "\n"))
	
func list(target):
	echo("console.rc")

func load_file(filename):
	var file    = File.new()
	var content = ""
	
	print("FILE DEBUG: ", filename.replace("period", "."))
	file.open(str('res://', filename.replace("period", ".")), file.READ)
	content = file.get_as_text()
	file.close()
	
	return content
	
func edit(filename):
	var file = File.new()
	print("FILE DEBUG: ", filename.replace("period", "."))
	file.open(str('res://', filename.replace("period", ".")), file.READ)
	print(file.get_as_text())
	echo(file.get_as_text())
	file.close()
	
func install(package):
	var root      = get_parent()
	var installer = root.get_node('installer')
	
	installer.call(package)

func build(type):
	var root   = get_parent()
	var camera = root.get_node('Camera')
	var server = load(str('res://', type, '.tscn'))
	
	if server == null:
		echo("resource not found!")
	else:
		var instance = server.instance()
		
		if root.money - instance.price >= 0:
			var trans = camera.get_global_transform().origin - Vector3(0, 0, 5)
			
			instance.set_translation(trans)
			root.call_deferred('add_child', instance)
			root.players.append(instance)
			
			print('Built a server!')
		else:
			echo("insufficient funds!")
			
func config(server):
	var root    = get_parent()
	var players = root.players
	
	for p in players:
		if PoolStringArray(p.ip) == server.split('period'):
			p.config()
	
func scan():
	var root    = get_parent()
	var players = root.players
	
	for p in players:
		print(p.ping(), ' from ', PoolStringArray(p.ip).join('.'))

func quit(return_code):
	get_tree().quit()
