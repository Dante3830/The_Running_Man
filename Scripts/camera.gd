extends Camera2D

@export var smooth = 4
@export var clamped = 10.5

@onready var player = get_parent().get_node("Player1")

func _process(delta):
	if transform.origin.x < player.transform.origin.x:
		transform.x = lerp(position.x, player.transform.origin.x, smooth * delta)
	
	position.x = clamp(position.x, -17.8, clamped)
