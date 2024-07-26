extends Area3D

var index = 0
var strength = 10

func _on_player_attack_body_entered(body):
	#print("Cuerpo detectado: ", body.name, " en capa: ", body.get_collision_layer())
	
	# Enemigo
	if body.get_collision_layer() == 2:
		Global.score += 100
		body.take_damage(index, strength)
		print("Enemigo golpeado")
	
	# Barril
	if body.get_collision_layer() == 16:
		print("Barril golpeado")
		Global.score += 500
		body.drop_item()

func _on_timer_timeout():
	queue_free()
