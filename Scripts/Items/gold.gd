extends Area3D

func _on_body_entered(body):
	if body.name == "Player1" or body.name == "Player2":
		Global.score += 2000
		queue_free()
