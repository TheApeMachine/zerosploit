extends LineEdit

func _ready():
	var root = get_parent().get_parent().get_parent()
	var http = root.get_node('HTTPRequest')
	http.request("http://zerosploit-api.herokuapp.com/ips.json")

func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
	self.text = json.result.ip
