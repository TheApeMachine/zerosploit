extends Spatial

var players      = []
var console_show = false
var money        = 1000
var bandwidth    = 14.4
var timecop      = Timer.new()

func _ready():
	$console.hide()
	timecop.set_wait_time(10)
	timecop.connect("timeout", self, "_on_timecop_timeout")
	add_child(timecop)
	timecop.start()

func _input(event):
	if event.is_pressed():
		if console_show == false:
			$console.show()
			$console.grab_focus()
			
func _on_timecop_timeout():
	for player in players:
		if len(player.connections) == 0:
			if player.delete_tag == false:
				player.delete_tag = true
				
				$console.echo("Zombie (unconnected) instance(s) in your network!")
				$console.echo("Tagged for deletion at next timecop run...")
			else:
				players.remove(player)
				player.queue_free()
				
				$console.echo("Zombie instance(s) deleted!")
				