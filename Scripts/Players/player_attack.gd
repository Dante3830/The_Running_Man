extends Area3D

var index = 0
var strength = 10

func _on_player_attack_body_entered(body):
	# Enemigo
	if body.get_collision_layer() == 2:
		Global.score += 50
		body.take_damage(index, strength)
	
	# Barril
	if body.get_collision_layer() == 16:
		Global.score += 300
		body.take_damage(index, strength)

func _on_timer_timeout():
	queue_free()
