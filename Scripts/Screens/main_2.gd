extends Node3D

var enemies_deaths = 0

@onready var camera = $Camera
@onready var ui_canvas = $UICanvas

func enemy_death():
	enemies_deaths += 1
	match enemies_deaths:
		2: next_area(3.0)
		6: next_area(5.0)
		13: next_area(8.0)

func next_area(limit : float):
	camera.set_camera_limit(limit)
	ui_canvas.show_go_sign()

func _on_next_area_door_body_entered(body):
	if body.is_in_group("Players"):
		get_tree().change_scene_to_file("res://Scenes/Screens/Main3.tscn")
