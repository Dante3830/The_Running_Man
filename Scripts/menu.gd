extends Control

# Empezar nivel
func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/Main1.tscn")
	Global.start_game_config()

# Salir de la aplicacion
func _on_exit_button_pressed():
	get_tree().quit()
