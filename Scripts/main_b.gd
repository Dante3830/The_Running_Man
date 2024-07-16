extends Node3D

@onready var level_time_DP = $CanvasLayer/LevelTimeDP
var time = 99

func _process(delta):
	level_time_DP.text = str(int(Global.level_time))
