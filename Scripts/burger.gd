extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		Global.player_1_health += 3
		queue_free()
