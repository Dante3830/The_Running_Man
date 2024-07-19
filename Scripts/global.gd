extends Node

var two_players_mode = false

var player_1_health = 100
var player_1_lives = 5

var player_2_health = 100
var player_2_lives = 5

var level_time = 99

func _process(delta):
	player_1_health = clamp(player_1_health, 0, 100)
	player_1_lives = clamp(player_1_lives, 0, 9)
	level_time -= (1.0/3.0) * delta
	
	if !two_players_mode:
		if player_1_lives == 0 and player_1_health == 0:
			get_tree().change_scene_to_file("res://Scenes/Screens/GameOver.tscn")
	else:
		if player_1_lives == 0 and player_1_health == 0 and player_2_lives == 0 and player_2_health == 0:
			get_tree().change_scene_to_file("res://Scenes/Screens/GameOver.tscn")

func start_game_config():
	if two_players_mode:
		player_1_health = 100
		player_1_lives = 5
		player_2_health = 100
		player_2_lives = 5
		level_time = 99
	else:
		player_1_health = 100
		player_1_lives = 5
		level_time = 99
