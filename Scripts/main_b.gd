extends Node3D

@onready var level_time_DP = $CanvasLayer/LevelTimeDP
var time = 99

func _process(delta):
	level_time_DP.text = str(int(Global.level_time))
	
	if Global.player_1_lives < 0:
		print("Game Over")
		get_tree().change_scene_to_file("res://Scenes/Screens/GameOver.tscn")
