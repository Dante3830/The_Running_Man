extends Control

func _process(_delta):
	$ScoreDP.text = str(Global.score)
	if !Global.two_players_mode:
		$YourScore.text = "Tu puntaje:"
	else:
		$YourScore.text = "Su puntaje:"

# Reiniciar el nivel
func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/Main1.tscn")
	Global.start_game_config()

# Volver al menu principal
func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/Menu.tscn")
