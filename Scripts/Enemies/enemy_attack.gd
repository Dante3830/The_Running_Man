extends Area3D

var index = 0
var strength = 10

func _on_player_attack_body_entered(body):
	if body.get_collision_layer() == 1:
		body.take_damage(strength)
		print(body.name + ": " + str(Global.player_1_health))

func _on_timer_timeout():
	queue_free()
