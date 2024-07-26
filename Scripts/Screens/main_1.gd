extends Node3D

var enemies_deaths = 0

@onready var camera = $Camera
@onready var ui_canvas = $UICanvas
@onready var spawn_point_1 = $"SPAWN POINTS/SpawnPoint1"
@onready var spawn_point_2 = $"SPAWN POINTS/SpawnPoint2"

#@export var enable_spawn = true

func _ready():
	# Spawnear jugadores en las posiciones iniciales
	spawn_players()
	
	# Configurar las barras de salud al inicio del juego
	ui_canvas.set_player_health_bar_properties(1, {
		"size": Vector2(240, 25),
		"rotation": 0,
		"position": Vector2(66, 81)
	})
	ui_canvas.set_player_health_bar_properties(2, {
		"size": Vector2(240, 25),
		"rotation": 180,
		"position": Vector2(539, 131)
	})

func spawn_players():
	var player_1 = null
	var player_2 = null
	
	if Global.player_1_name == "Richard":
		player_1 = preload("res://Scenes/Players/Player1.tscn").instantiate()
		player_1.position = spawn_point_1.position
		add_child(player_1)
		player_1.connect("player_died", Callable(self, "on_player_died"))
	elif Global.player_1_name == "Amber":
		player_1 = preload("res://Scenes/Players/Player2.tscn").instantiate()
		player_1.position = spawn_point_1.position
		add_child(player_1)
		player_1.connect("player_died", Callable(self, "on_player_died"))
		
	if Global.two_players_mode:
		if Global.player_2_name == "Richard":
			player_2 = preload("res://Scenes/Players/Player1.tscn").instantiate()
			player_2.position = spawn_point_2.position
			add_child(player_2)
		elif Global.player_2_name == "Amber":
			player_2 = preload("res://Scenes/Players/Player2.tscn").instantiate()
			player_2.position = spawn_point_2.position
			add_child(player_2)
	
	 # Agregar un pequeño retraso
	#await get_tree().create_timer(0.1).timeout
	
	# Colocar los jugadores en su posición
	if player_1:
		player_1.global_position = spawn_point_1.global_position
	if player_2:
		player_2.global_position = spawn_point_2.global_position
	
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
	if body.get_collision_layer() == 2:
		get_tree().change_scene_to_file("res://Scenes/Screens/Main2.tscn")

func respawn_player(player):
	# Determinar el punto de spawn correcto
	var spawn_point = spawn_point_1 if player.name == "Player1" else spawn_point_2
	
	# Mover al jugador al punto de spawn
	player.global_position = spawn_point.global_position
	
	# Llamar a la función de respawn del jugador
	player.respawn()
	
	# Actualizar la UI
	ui_canvas.update_player_1_hud()

func on_player_died(player):
	var player_number = 1 if player.name == "Player1" else 2
	var spawn_point = spawn_point_1 if player_number == 1 else spawn_point_2
	
	# Esperar un poco antes de hacer respawn
	await get_tree().create_timer(1.0).timeout
	
	# Crear una nueva instancia del jugador
	var new_player
	if Global.get("player_{n}_name".format({"n": player_number})) == "Richard":
		new_player = preload("res://Scenes/Players/Player1.tscn").instantiate()
	else:
		new_player = preload("res://Scenes/Players/Player2.tscn").instantiate()
	
	new_player.position = spawn_point.position
	add_child(new_player)
	new_player.connect("player_died", Callable(self, "on_player_died"))
	
	# Restablecer la salud del jugador
	Global.set("player_{n}_health".format({"n": player_number}), 100)
	
	# Recrear la barra de salud en la UI
	ui_canvas.recreate_health_bar(player_number)
	
	# Actualizar la UI
	if player_number == 1:
		ui_canvas.update_player_1_hud()
	else:
		ui_canvas.update_player_2_hud()
	
	# Notificar a la cámara del nuevo jugador
	camera.set_players(new_player, null) if player_number == 1 else camera.set_players(null, new_player)
