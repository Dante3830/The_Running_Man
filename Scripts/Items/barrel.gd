extends Area3D

@export var drop_object : PackedScene = null

func take_damage(damage_index : int, damage : int):
	drop_item()
	$AnimationPlayer.play("shake")

func drop_item():
	if drop_object:
		var Drop = drop_object.instantiate()
		Drop.transform.origin = transform.origin
		get_parent().add_child(Drop)

func _on_animation_player_animation_finished():
	queue_free()
