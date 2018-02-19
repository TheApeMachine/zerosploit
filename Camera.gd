extends Camera

var dir = {
	"N":[
		Vector3(0, 0, -1), 
		Vector3(0, 0, 1), 
		Vector3(-1, 0, 0),
		Vector3(1, 0, 0)
	],
	"S":[
		Vector3(0, 0, 1),
		Vector3(0, 0, -1),
		Vector3(1, 0, 0),
		Vector3(-1, 0, 0)
	],
	"W":[
		Vector3(-1, 0, 0),
		Vector3(1, 0, 0),
		Vector3(0, 0, 1),
		Vector3(0, 0, -1)
	],
	"O":[
		Vector3(1, 0, 0),
		Vector3(-1, 0, 0),
		Vector3(0, 0, -1),
		Vector3(0, 0, 1)
	]
}

var direct  = ["N", "W", "S", "O"]
var move    = "stop"
var step    = 0
var pos     = Vector3(10, 1, 10)
var rotL    = 0;
var rotR    = 0;
var id      = {16777232:0, 16777234:1, 16777231:2, 16777233:3}
var root    = false
var console = false

func _ready():
	self.set_translation(Vector3(pos.x, 1, pos.x))
	
	root    = get_parent()
	console = root.get_node('console')
	
	set_process(true)

func step_mov(key):
	if (Input.is_key_pressed(key) and move == "stop") or move == direct[id[key]]:
		move  = direct[id[key]]
		step += 1
		pos  += 0.02 * dir[direct[0]][id[key]]
		
		if step == 50:
			move = "stop"
			step = 0
			pos  = Vector3(round(pos.x), 1, round(pos.z))
		
		self.set_translation(Vector3(pos.x, 1, pos.z))
		
func rot():
	if (Input.is_key_pressed(16777235)) and step == 0 and rotR == 0 or rotL != 0:
		if rotL == 0:
			direct.push_back(direct[0])
			direct.pop_front()
		
		rotL += 1
		
		if rotL == 100:
			rotL = 0
			
		self.rotate(Vector3(0, 1, 0), -0.0157)
		
	if (Input.is_key_pressed(16777236)) and step == 0 and rotL == 0 or rotR != 0:
		if rotR == 0:
			direct.push_front(direct[3])
			direct.pop_back()
			
		rotR += 1
		
		if rotR == 100:
			rotR = 0
			
		self.rotate(Vector3(0, 1, 0), 0.0157)
		
func _process(delta):
	if console && console.shown:
		pass
	else:
		step_mov(KEY_UP)
		step_mov(KEY_DOWN)
		step_mov(KEY_LEFT)
		step_mov(KEY_RIGHT)
		rot()
		