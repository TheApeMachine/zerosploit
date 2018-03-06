extends TextEdit

var shown    = false
var editing  = false
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
	'EDIT',
	'LOGIN'
]

func _ready():
	var init = load_file('console.rc').split("\n")
	
	for i in init:
		lexer(i.to_upper() + "\n")
	
	insert_text_at_cursor(">")
	
func _input(event):
	if editing == false:
		if Input.is_key_pressed(KEY_ENTER):
			cmd += "\n"
			get_tree().set_input_as_handled()
			insert_text_at_cursor(">")
			write_log(cmd)
			lexer(cmd.to_upper())
			cmd = ""
		elif !event.is_pressed() and !event.is_class("InputEventMouseMotion"):
			var e = event.as_text()
			
			if e == 'Space':
				cmd += ' '
			elif e == 'BackSpace':
				cmd = cmd.left(len(cmd) - 1)
			elif e == 'Enter' or e == 'Down' or e == 'Up' or e == 'Left' or e == 'Right':
				pass
			elif e == 'Escape':
				hide()
				shown = false
			elif e == 'Tab':
				get_tree().set_input_as_handled()
				tab_complete()
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
	
func write_log(string):
	var time   = OS.get_time()
	var hour   = time.hour
	var minute = time.minute
	var second = time.second
	var date   = OS.get_date()
	var day    = date.day
	var month  = date.month
	var year   = date.year
	var file   = File.new()
	
	file.open('res://filesystem/logfile', file.READ_WRITE)
	file.seek_end()
	file.store_string(str(
		'[', year, '/', month, '/', day, ' @ ', hour, ':', minute, ':', second, '] ', string, "\n"
	))
	file.close()
	
func echo(string):
	write_log(str(string))
	
	if editing == false:
		insert_text_at_cursor(str("\n", string, "\n"))
	
func tab_complete():
	var files = read_dir("")
	
	for file in files:
		if cmd.to_lower() == file.left(len(cmd)):
			cmd += file.right(len(cmd)).to_upper()
			insert_text_at_cursor(cmd.to_lower())
	
func read_dir(target):
	var files = []
	var dir   = Directory.new()
	dir.open(str("filesystem/", target))
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
			
	dir.list_dir_end()
	
	return files
	
func list(target):
	var files = read_dir(target)
	echo(files)
	
func load_file(filename):
	var file    = File.new()
	var content = ""
	
	print("FILE DEBUG: ", filename.replace("period", "."))
	file.open(str('res://filesystem/', filename.replace("period", ".")), file.READ)
	content = file.get_as_text()
	file.close()
	
	return content
	
func edit(filename):
	var root    = get_parent()
	var editor  = root.get_node('editor')
	var content = load_file(filename)
	
	editing = true
	
func login(tmp):
	var root    = get_parent()
	var account = root.get_node('account')
	account.login()
	
func install(package):
	var root      = get_parent()
	var installer = root.get_node('installer')
	
	installer.call(package)

func build(type):
	var root   = get_parent()
	var camera = root.get_node('player')
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
			echo("Insufficient funds!")
			
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
