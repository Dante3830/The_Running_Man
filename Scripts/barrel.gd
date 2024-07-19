extends StaticBody3D

@export var drop : PackedScene = null

func take_damage(_damage_index : int, _damage : int):
	drop_item()
	$AnimationPlayer.play("shake")

func drop_item():
	if drop:
		var d = drop.instantiate()
		d.transform.origin = transform.origin
		get_parent().add_child(d)

func _on_animation_player_animation_finished():
	queue_free()
