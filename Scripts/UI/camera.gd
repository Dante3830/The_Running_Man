extends Camera3D

@export var smooth = 4
@export var clamped = 10.5

var player_1 = null
var player_2 = null

func set_players(p1, p2):
	player_1 = p1
	player_2 = p2

func _process(delta):
	if player_1 and player_1.transform.origin.x > transform.origin.x:
		position.x = lerp(position.x, player_1.transform.origin.x, smooth * delta)
	
	position.x = clamp(position.x, -17.8, clamped)

func set_camera_limit(limit : float):
	clamped = limit
