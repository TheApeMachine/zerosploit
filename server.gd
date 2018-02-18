extends Spatial

var ip = [1, 0, 0, 0]

func _ready():
	randomize()

	ip = [
		randi() % 255 + 1,
		randi() % 255 + 1,
		randi() % 255 + 1,
		randi() % 255 + 1
	]

func ping():
	return "pong"