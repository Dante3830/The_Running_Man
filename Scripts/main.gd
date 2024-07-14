# MAIN
extends Node2D

@onready var PlayerScene = preload("res://Scenes/Players/Player1.tscn")
@onready var respawn_timer = $RespawnTimer
@onready var level_time_DP = $CanvasLayer/LevelTimeDP

# Añadir una referencia al punto de respawn
@onready var respawn_point = $RespawnPoint

var player_instance
var is_respawning = false

func _ready():
	# Instanciar el jugador al inicio del juego
	spawn_player()

func _process(_delta):
	level_time_DP.text = str(int(Global.level_time))
	
	# Verificamos si el jugador está muerto y si el temporizador de respawn no está activo
	if player_instance and player_instance.is_dead and not is_respawning:
		print("Player is dead, starting respawn timer")
		Global.player_1_lives -= 1
		is_respawning = true
		respawn_timer.start()

	if Global.player_1_lives < 0:
		print("Game Over")
		get_tree().change_scene_to_file("res://Scenes/Screens/GameOver.tscn")

func spawn_player():
	print("Spawning player...")
	player_instance = PlayerScene.instantiate()
	add_child(player_instance)
	# Usar la posición del nodo RespawnPoint para el jugador
	player_instance.global_position = respawn_point.global_position

func respawn_player():
	print("Respawning player...")
	if player_instance:
		player_instance.queue_free()
	player_instance = PlayerScene.instantiate()
	add_child(player_instance)
	# Usar la posición del nodo RespawnPoint para el jugador
	player_instance.global_position = respawn_point.global_position
	player_instance.respawn()
	is_respawning = false
	print("Player respawned")

func _on_respawn_timer_timeout():
	respawn_player()
