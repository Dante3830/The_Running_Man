# MAIN
extends Node2D

@onready var PlayerScene = preload("res://Scenes/Player.tscn")
@onready var respawn_timer = $RespawnTimer

var player_instance
var is_respawning = false

func _ready():
	# Instanciar el jugador al inicio del juego
	spawn_player()

func _process(_delta):
	# Verificamos si el jugador está muerto y si el temporizador de respawn no está activo
	if player_instance and player_instance.is_dead and not is_respawning:
		print("Player is dead, starting respawn timer")
		Global.player_1_lives -= 1
		is_respawning = true
		respawn_timer.start()

	if Global.player_1_lives < 0:
		print("Game Over")
		get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")

func spawn_player():
	print("Spawning player...")
	player_instance = PlayerScene.instantiate()
	add_child(player_instance)
	player_instance.set_respawn_position()

func respawn_player():
	print("Respawning player...")
	if player_instance:
		player_instance.queue_free()
	player_instance = PlayerScene.instantiate()
	add_child(player_instance)
	player_instance.set_respawn_position()
	player_instance.respawn()
	is_respawning = false
	print("Player respawned")

func _on_respawn_timer_timeout():
	respawn_player()
