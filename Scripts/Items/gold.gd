extends Area3D

func _on_body_entered(body):
	if body.name == "Richard" or body.name == "Amber":
		Global.score += 2000
		queue_free()
