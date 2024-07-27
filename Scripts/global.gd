extends Node

var one_player_mode = true
var two_players_mode = false

var player_1_health = 0
var player_1_lives = 5
var player_1_name : String = ""

var player_2_health = 100
var player_2_lives = 5
var player_2_name : String = ""

var score : int = 000000
var next_life_score_threshold = 10000

var level_time = 99
var is_time_up = false
signal level_time_up

func _process(delta):
	player_1_health = clamp(player_1_health, 0, 100)
	player_2_health = clamp(player_2_health, 0, 100)
	
	level_time -= (1.0 / 5.0) * delta
	
	if !two_players_mode:
		if player_1_lives == 0 and player_1_health == 0:
			get_tree().change_scene_to_file("res://Scenes/Screens/GameOver.tscn")
	else:
		if player_1_lives == 0 and player_1_health == 0 and player_2_lives == 0 and player_2_health == 0:
			get_tree().change_scene_to_file("res://Scenes/Screens/GameOver.tscn")
	
	time_up()
	check_for_extra_life()

func start_game_config():
	if two_players_mode:
		player_1_health = 100
		player_1_lives = 5
		player_2_health = 100
		player_2_lives = 99
		level_time = 99
	else:
		player_1_health = 100
		player_1_lives = 5
		level_time = 99
	next_life_score_threshold = 10000

func check_for_extra_life():
	if score >= next_life_score_threshold:
		if !two_players_mode:
			player_1_lives += 1
			next_life_score_threshold += 10000
		else:
			player_1_lives += 1
			player_2_lives += 1
			next_life_score_threshold += 10000

func time_up():
	if level_time <= 0:
		is_time_up = true
		if player_1_health > 0:  # Solo si el jugador aún tiene salud
			player_1_health = 0
		
		if two_players_mode and player_2_health > 0:
			player_2_health = 0
		
		# Reiniciar el tiempo del nivel
		level_time = 99  # O el valor inicial que prefieras
		
		# Emitir una señal para manejar el respawn
		emit_signal("level_time_up")
	else:
		is_time_up = false
