extends StaticBody3D

@export var drop_object : PackedScene = null

func take_damage(_damage_index : int, _damage : int):
	drop_item()
	$AnimationPlayer.play("shake")

func drop_item():
	if drop_object:
		var Drop = drop_object.instantiate()
		var drop_position = transform.origin
		drop_position.y -= 0.2
		Drop.transform.origin = drop_position
		get_parent().add_child(Drop)

func _on_animation_player_animation_finished(animation : String):
	if animation == "shake":
		queue_free()
