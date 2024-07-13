extends Camera2D

var player = null
var follow_player = true

func _ready():
	player = $Player  # Asegúrate de reemplazar 'Player' con el nombre de tu nodo de jugador

func _process(delta):
	if follow_player:
		# Seguir al jugador
		position = player.global_position
	else:
		# Lógica para detener la cámara en zonas específicas
		# Por ejemplo, si se activa una zona de detención
		# puedes dejar de seguir al jugador y mantener la cámara en una posición fija
		position = Vector2(x, y)  # Coordenadas fijas o de otro nodo

func set_follow_player(follow):
	follow_player = follow
