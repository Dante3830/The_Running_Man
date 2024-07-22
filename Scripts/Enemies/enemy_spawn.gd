extends Area3D

@export var enemy_amount = 0

const ENEMIES = [preload("res://Scenes/Enemies/Enemy1.tscn")]

func _ready():
	randomize()

func _on_enemy_spawn_body_entered(_body):
	spawn_enemies(enemy_amount)

func spawn_enemies(amount : int):
	for i in amount:
		var enemy = ENEMIES[randi() % ENEMIES.size()].instantiate()
		enemy.transform.origin = set_enemy_random_position()
		get_parent().add_child(enemy)
	queue_free()

func set_enemy_random_position() -> Vector3:
	var side = randi() % 2
	var new_position : Vector3
	match side:
		0: new_position = Vector3(get_parent().get_node("Camera").transform.origin.x - 1, -0.184, randf_range(0.449, 1.0))
		1: new_position = Vector3(get_parent().get_node("Camera").transform.origin.x + 1, -0.184, randf_range(0.449, 1.0))
	return new_position
