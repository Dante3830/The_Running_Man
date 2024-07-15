#extends Camera2D
#
#var player = null
#var follow_player = true
#var fixed_position = Vector2()
#
#func _ready():
	# Conectar la señal del nodo que instancia al jugador
	#var instancer = get_node("/root/PathToInstancerNode")
	#instancer.connect("player_instantiated", self, "_on_player_instantiated")
#
#func _process(delta):
	#if follow_player and player:
		# Seguir al jugador
		#position = player.global_position
	#else:
		# Mantener la cámara en una posición fija
		#position = fixed_position
#
#func _on_player_instantiated(player_instance):
	#player = player_instance
#
#func set_follow_player(follow, new_fixed_position = Vector2()):
	#follow_player = follow
	#if not follow:
		#fixed_position = new_fixed_position
