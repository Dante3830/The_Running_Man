extends Area3D

var index = 0
var strength = 10

func _on_player_attack_body_entered(body):
	#print("Cuerpo detectado: ", body.name, " en capa: ", body.get_collision_layer())
	
	# Enemigo
	if body.get_collision_layer() == 2:
		Global.score += 50
		body.take_damage(index, strength)
		#print("Enemigo golpeado")
	
	# Barril
	if body.get_collision_layer() == 16:
		#print("Barril golpeado")
		Global.score += 300
		body.take_damage(index, strength)

func _on_timer_timeout():
	queue_free()
