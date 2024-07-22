extends Control

# Empezar nivel modo un jugador
func _on_one_player_button_pressed():
	Global.two_players_mode = false
	Global.start_game_config()
	get_tree().change_scene_to_file("res://Scenes/Screens/CharacterSelect.tscn")

# Empezar nivel modo dos jugadores
func _on_two_players_button_pressed():
	Global.two_players_mode = true
	Global.start_game_config()
	get_tree().change_scene_to_file("res://Scenes/Screens/CharacterSelect.tscn")

# Ver los controles
func _on_controls_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/Controls.tscn")

# Salir de la aplicacion
func _on_exit_button_pressed():
	get_tree().quit()
