extends Area3D

@export var enemy_a_amount = 0
@export var enemy_b_amount = 0
@export var enemy_c_amount = 0

const ENEMIES_A = [preload("res://Scenes/Enemies/EnemyA.tscn")]
const ENEMIES_B = [preload("res://Scenes/Enemies/EnemyB.tscn")]
const ENEMIES_C = [preload("res://Scenes/Enemies/EnemyC.tscn")]

@onready var camera = get_parent().get_node("Camera")

func _ready():
	randomize()

func _on_enemy_spawn_body_entered(_body):
	spawn_enemies(enemy_a_amount, enemy_b_amount, enemy_c_amount)

func spawn_enemies(amount_a : int, amount_b : int, amount_c : int):
	for i in amount_a:
		var enemy_a = ENEMIES_A[randi() % ENEMIES_A.size()].instantiate()
		enemy_a.transform.origin = set_enemy_random_position()
		get_parent().add_child(enemy_a)
	for i in amount_b:
		var enemy_b = ENEMIES_B[randi() % ENEMIES_B.size()].instantiate()
		enemy_b.transform.origin = set_enemy_random_position()
		get_parent().add_child(enemy_b)
	for i in amount_c:
		var enemy_c = ENEMIES_C[randi() % ENEMIES_C.size()].instantiate()
		enemy_c.transform.origin = set_enemy_random_position()
		get_parent().add_child(enemy_c)
	queue_free()

func set_enemy_random_position() -> Vector3:
	var side = randi() % 2
	var new_position : Vector3
	match side:
		0: new_position = Vector3(camera.transform.origin.x - 4, -0.184, randf_range(0.444, 2.2))
		1: new_position = Vector3(camera.transform.origin.x + 4, -0.184, randf_range(0.444, 2.2))
	return new_position
