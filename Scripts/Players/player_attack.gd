extends Area3D

var index = 0
var strength = 10

func _on_player_attack_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(index, strength)
		print(body.name + ": " + str(body.life))
	
	if body.get_collision_layer() == 2:
		Global.score += 100
		print("Enemigo golpeado")
	
	if body.get_collision_layer() == 5:
		print("Caja golpeada")
		Global.score += 500
		#body.take_damage(index, strength)

func _on_timer_timeout():
	queue_free()
