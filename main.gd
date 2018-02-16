extends Spatial

var console_show = false

func _ready():
	$console.hide()

func _input(event):
	if event.is_pressed():
		if console_show == false:
			$console.show()
			$console.grab_focus()
			