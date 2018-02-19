extends Spatial

var players      = []
var console_show = false
var money        = 1000
var bandwidth    = 14.4

func _ready():
	$console.hide()

func _input(event):
	if event.is_pressed():
		if console_show == false:
			$console.show()
			$console.grab_focus()
			