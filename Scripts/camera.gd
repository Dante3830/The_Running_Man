extends Camera2D

var player = null
var follow_player = true
var fixed_position = Vector2()

func _ready():
	player = $Player  # Asegúrate de reemplazar 'Player' con el nombre de tu nodo de jugador

	# Suponiendo que tienes nodos Position2D en tu escena para posiciones fijas de la cámara
	# Puedes agregarlos al script para poder referenciarlos
	# Ejemplo:
	# fixed_position = $FixedPosition1.position

func _process(_delta):
	if follow_player:
		# Seguir al jugador
		position = player.global_position
	else:
		# Mantener la cámara en una posición fija
		position = fixed_position

func set_follow_player(follow, new_fixed_position = Vector2()):
	follow_player = follow
	if not follow:
		fixed_position = new_fixed_position
