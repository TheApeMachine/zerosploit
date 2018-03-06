extends Node

var cmd             = ""
var account_details = []
var current_index   = 0

func _ready():
	pass

func _input(event):
	var root    = get_parent()
	var console = root.get_node('console')

	if Input.is_key_pressed(KEY_ENTER):
		account_details[current_index] = cmd
		
		if current_index == 1:
			console.insert_text_at_cursor('password: ')
		elif current_index == 2:
			console.insert_text_at_cursor('password_confirmation: ')
		elif current_index == 3:
			var http = root.get_node('HTTPRequest')
			
			HTTPClient.request(2, 'http://zerosploit-api.herokuapp.com/users.json', [], str("handle=", account_details[0], "&password=", account_details[1], "&password_confirmation=", account_details[2]))
			
		cmd = ""
		current_index += 1

	elif !event.is_pressed() and !event.is_class("InputEventMouseMotion"):
		cmd += event.as_text()


func login():
	var root    = get_parent()
	var console = root.get_node('console')
	
	console.insert_text_at_cursor('handle: ')