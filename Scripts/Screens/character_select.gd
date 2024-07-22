extends Control

func _process(_delta):
	pass

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/Menu.tscn")
