extends Control

# Volver a cargar nivel principal
func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/Main1.tscn")
	Global.start_game_config()

# Cargar menu principal
func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/Menu.tscn")
