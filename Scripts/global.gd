extends Node

var player_1_health = 10
var player_1_lives = 5

func _process(_delta):
	player_1_health = clamp(player_1_health, 0, 10)
	player_1_lives = clamp(player_1_lives, 0, 9)
