extends Camera3D

@export var smooth = 4
@export var clamped = 10.5

var player_1 = null
var player_2 = null

func set_players(p1, p2):
	if p1:
		player_1 = p1
	if p2:
		player_2 = p2

func _process(delta):
	var target_player = get_target_player()
	
	if target_player:
		if target_player.transform.origin.x > transform.origin.x:
			position.x = lerp(position.x, target_player.transform.origin.x, smooth * delta)
	
	position.x = clamp(position.x, -17.8, clamped)

func set_camera_limit(limit : float):
	clamped = limit

func get_target_player():
	if is_instance_valid(player_1):
		return player_1
	elif is_instance_valid(player_2):
		return player_2
	else:
		find_new_players()
		return player_1 if is_instance_valid(player_1) else player_2

func find_new_players():
	var players = get_tree().get_nodes_in_group("Players")
	if players.size() > 0:
		player_1 = players[0]
	if players.size() > 1:
		player_2 = players[1]
