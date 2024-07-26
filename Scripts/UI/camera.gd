extends Camera3D

@export var smooth = 4
@export var clamped = 10.5

var player_1 = null
var player_2 = null

func set_players(p1, p2):
	player_1 = p1
	player_2 = p2

func _process(delta):
	if is_instance_valid(player_1):
		if player_1.transform.origin.x > transform.origin.x:
			position.x = lerp(position.x, player_1.transform.origin.x, smooth * delta)
	else:
		# Si player_1 no es válido, buscar un nuevo jugador
		find_new_player()
	
	position.x = clamp(position.x, -17.8, clamped)

func set_camera_limit(limit : float):
	clamped = limit

func find_new_player():
	# Buscar un nuevo jugador en la escena
	var new_player = get_tree().get_nodes_in_group("players")
	if new_player.size() > 0:
		player_1 = new_player[0]
	else:
		player_1 = null
