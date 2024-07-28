extends Area3D

func _on_body_entered(body):
	if body.is_in_group("Players"):
		Global.score += 1000
		queue_free()
