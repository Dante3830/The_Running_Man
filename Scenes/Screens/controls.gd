extends Control

# Volver al menu principal
func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/Menu.tscn")

# Salir del juego
func _on_exit_button_pressed():
	get_tree().quit()
