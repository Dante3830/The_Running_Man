extends Node3D

const RESPAWN_HEIGHT_OFFSET = 2.0 

var enemies_deaths = 0

@onready var camera = get_node("Camera")
@onready var ui_canvas = $UICanvas
@onready var spawn_point_1 = $"SPAWN POINTS/SpawnPoint1"
@onready var spawn_point_2 = $"SPAWN POINTS/SpawnPoint2"

@onready var boss = get_node("Boss")

func _ready():
	spawn_players()
	
	$SURFACE.hide()
	
	var player1_bar_props = ui_canvas.get_player_health_bar_properties(1)
	
	ui_canvas.set_player_health_bar_properties(2, {
		"size": Vector2(240, 25),
		"rotation": 180,
		"position": Vector2(539, 131)
	})
	
	var enemy_bar_props = ui_canvas.get_enemy_health_bar_properties()
	ui_canvas.set_enemy_health_bar_properties({
		"size": Vector2(240, 25),
		"rotation": 0,
		"position": Vector2(66, 81)
	})
	

func _physics_process(delta):
	if is_instance_valid(boss):
		if not boss.is_inside_tree():
			finish_level()
	else:
		finish_level()

func spawn_players():
	var player_1 = create_player(1, spawn_point_1.position)
	var player_2 = null
	if Global.two_players_mode:
		player_2 = create_player(2, spawn_point_2.position)
	
	if player_1:
		player_1.global_position = spawn_point_1.global_position
	if player_2:
		player_2.global_position = spawn_point_2.global_position
	
	if boss:
		boss.set_players(player_1, player_2)
	
	camera.set_players(player_1, player_2)

func create_player(player_number, spawn_position):
	var player
	if Global.get("player_{n}_name".format({"n": player_number})) == "Richard":
		player = preload("res://Scenes/Players/Richard.tscn").instantiate()
	elif Global.get("player_{n}_name".format({"n": player_number})) == "Amber":
		player = preload("res://Scenes/Players/Amber.tscn").instantiate()
	
	player.position = spawn_position
	add_child(player)
	#player.add_to_group("Players")
	player.connect("player_died", Callable(self, "on_player_died"))
	return player

func enemy_death():
	enemies_deaths += 1
	
	# Recrear la barra de vida del enemigo
	ui_canvas.recreate_enemy_health_bar()
	
	#match enemies_deaths:
		#0: next_area(1.0)
		#12: next_area(7.0)
		#24: next_area(13.0)
		#35: next_area(18.4)

func next_area(limit : float):
	camera.set_camera_limit(limit)
	ui_canvas.show_go_sign()

func on_player_died(player, last_position):
	var player_number
	
	if player.name == "Richard":
		player_number = 1
	else:
		player_number = 2
	
	# Eliminar el jugador actual
	player.queue_free()
	player.remove_from_group("Players")
	player.queue_free()
	
	# Esperar un poco antes de hacer respawn
	await get_tree().create_timer(1.0).timeout
	
	# Calcular la posición de respawn
	var respawn_position = last_position + Vector3(0, RESPAWN_HEIGHT_OFFSET, 0)
	
	var new_player = create_player(player_number, respawn_position)
	new_player.add_to_group("Players")
	
	Global.set("player_{n}_health".format({"n": player_number}), 100)
	
	ui_canvas.recreate_player_health_bar(player_number)
	
	if player_number == 1:
		ui_canvas.update_player_1_hud()
	else:
		ui_canvas.update_player_2_hud()
	
	if player_number == 1:
		camera.set_players(new_player, camera.player_2)
	else:
		camera.set_players(camera.player_1, new_player)

func finish_level():
	if not is_instance_valid(boss):
		get_tree().change_scene_to_file("res://Scenes/Screens/Victory.tscn")
