extends Node3D

var enemies_deaths = 0

@onready var camera = $Camera
@onready var ui_canvas = $UICanvas
@onready var spawn_point_1 = $"SPAWN POINTS/SpawnPoint1"
@onready var spawn_point_2 = $"SPAWN POINTS/SpawnPoint2"

func _ready():
	# Spawnear jugadores en las posiciones iniciales
	spawn_players()

func spawn_players():
	var player_1 = null
	var player_2 = null
	
	if Global.player_1_name == "Richard":
		player_1 = preload("res://Scenes/Players/Richard.tscn").instantiate()
		player_1.name = "Player1"
		player_1.position = spawn_point_1.position
		add_child(player_1)
	elif Global.player_1_name == "Amber":
		player_1 = preload("res://Scenes/Players/Amber.tscn").instantiate()
		player_1.name = "Player1"
		player_1.position = spawn_point_1.position
		add_child(player_1)
	
	if Global.two_players_mode:
		if Global.player_2_name == "Richard":
			player_2 = preload("res://Scenes/Players/Richard.tscn").instantiate()
			player_2.name = "Player2"
			player_2.position = spawn_point_2.position
			add_child(player_2)
		elif Global.player_2_name == "Amber":
			player_2 = preload("res://Scenes/Players/Amber.tscn").instantiate()
			player_2.name = "Player2"
			player_2.position = spawn_point_2.position
			add_child(player_2)
	
	# Notificar a la cámara que los jugadores han sido instanciados
	camera.set_players(player_1, player_2)

func enemy_death():
	enemies_deaths += 1
	match enemies_deaths:
		2: next_area(2.0)
		6: next_area(5.0)
		13: next_area(8.0)

func next_area(limit : float):
	camera.set_camera_limit(limit)
	ui_canvas.show_go_sign()

func _on_next_area_door_body_entered(body):
	if body.is_in_group("Players"):
		get_tree().change_scene_to_file("res://Scenes/Screens/Main3.tscn")
