extends Control

# Variables para rastrear las elecciones de los jugadores
var player1_selected = false
var player2_selected = false

func _ready():
	$Character1/Player1.hide()
	$Character1/Player2.hide()
	$Character2/Player1.hide()
	$Character2/Player2.hide()

# Botón de Richard (personaje 1)
func _on_character_1_button_pressed():
	if Global.one_player_mode:
		Global.player_1_name = "Richard"
		get_tree().change_scene_to_file("res://Scenes/Screens/Main1.tscn")
	elif Global.two_players_mode:
		if not player1_selected:
			Global.player_1_name = "Richard"
			player1_selected = true
			$Character1/Player1.show()
		elif not player2_selected:
			Global.player_2_name = "Richard"
			player2_selected = true
			$Character1/Player2.show()
		if player1_selected and player2_selected:
			await get_tree().create_timer(1.0).timeout
			get_tree().change_scene_to_file("res://Scenes/Screens/Main1.tscn")

# Botón de Amber (personaje 2)
func _on_character_2_button_pressed():
	if Global.one_player_mode:
		Global.player_1_name = "Amber"
		get_tree().change_scene_to_file("res://Scenes/Screens/Main1.tscn")
	elif Global.two_players_mode:
		if not player1_selected:
			Global.player_1_name = "Amber"
			player1_selected = true
			$Character2/Player1.show()
		elif not player2_selected:
			Global.player_2_name = "Amber"
			player2_selected = true
			$Character2/Player2.show()
		if player1_selected and player2_selected:
			await get_tree().create_timer(1.0).timeout
			get_tree().change_scene_to_file("res://Scenes/Screens/Main1.tscn")

# Volver al menú principal
func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/Menu.tscn")
