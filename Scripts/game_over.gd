extends Control

# Volver a cargar nivel principal
func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Mainb.tscn")

# Cargar menu principal
func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/Menu.tscn")
