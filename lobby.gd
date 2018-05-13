extends Spatial

func _ready():
	var Http = load("http.gd")

func _on_Button_pressed():
	var lineedit = get_node('PanelContainer/Panel/LineEdit')
	var ip       = lineedit.text
	
	var http = HTTPClient.new()
	var err = http.connect_to_host("zerosploit-api.herokuapp.com", 80)
	assert(err == OK)

	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
		print("Connecting...")
		OS.delay_msec(500)
	
	assert(http.get_status() == HTTPClient.STATUS_CONNECTED)
	
	var body = str("server[ip]=", ip)
	
	http.request(
		HTTPClient.METHOD_POST, 
		'/servers.json', 
		["Content-Type: application/x-www-form-urlencoded", "Content-Length: " + str(body.length())], 
		body
	)
