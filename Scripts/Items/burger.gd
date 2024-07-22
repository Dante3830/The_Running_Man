extends Area3D

func _on_body_entered(body):
	Global.score += 250
	if body.name == "Player1":
		Global.player_1_health += 25
		queue_free()
	
	if body.name == "Player2":
		Global.player_2_health += 25
		queue_free()
