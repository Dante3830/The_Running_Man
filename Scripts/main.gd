extends Node2D

#func _ready():
	#$LIMITS/TopLimit.connect("body_entered", Callable(self, "_on_top_limit_body_entered"))
	#$LIMITS/BottomLimit.connect("body_entered", Callable(self, "_on_bottom_limit_body_entered"))
#
#func _on_top_limit_body_entered(body):
	#if body is CharacterBody2D:
		#body.position.y = $LIMITS/TopLimit.position.y + $LIMITS/TopLimit.shape.extents.y  # Ajustar la posición para que esté justo debajo del límite
#
#func _on_bottom_limit_body_entered(body):
	#if body is CharacterBody2D:
		#body.position.y = $LIMITS/BottomLimit.position.y - $LIMITS/BottomLimit.shape.extents.y  # Ajustar la posición para que esté justo encima del límite
