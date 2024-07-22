extends CharacterBody3D

const ATTACK = preload("res://Scenes/Enemies/EnemyAttack.tscn")

# Velocidad
@export var speed_default = 1.0

# Vida
@export var life_default = 100
@export var cooldown_attack = 1.0
@export var enemy_name = ""

var death = false
var facing_right = false
var in_attack = false
var can_attack = true

var on_hit = false

var motion : Vector3

var knockback : Vector3
var knockback_speed = 0.5

var take_damage_entry = false
var take_damage_index = 0

var walk_timer = 0.0

var x_direction = 0.0
var z_direction = 0.0

@onready var speed = speed_default
@onready var life = life_default
@onready var animated_sprite = $AnimatedSprite3D
@onready var player = get_parent().get_node("Player1")
@onready var take_damage_timer = $TakeDamageTimer
@onready var ui_canvas = get_parent().get_node("UICanvas")

func _ready():
	randomize()

func _process(delta):
	# Gravedad
	motion.y -= 9.8 * delta
	
	# Si no hay nada, se pone el nombre por defecto
	if enemy_name == "":
		enemy_name = "Jim"
	
	_movement(delta)
	_animations()
	_flip()

func _physics_process(_delta):
	if death and on_hit or on_hit:
		_knockback()
	
	# Aplicar movimiento
	move_and_collide(motion)

func _movement(delta):
	if take_damage_entry:
		return
	
	if !death and !in_attack:
		var target_distance = player.transform.origin - transform.origin
		x_direction = target_distance.x / abs(target_distance.x)
		
		walk_timer += delta
		if walk_timer > randf_range(1.0, 2.0):
			z_direction = randi() % 3 - 1
			walk_timer = 0.0
		
		if abs(target_distance.x) < 1:
			x_direction = 0
		
		if abs(target_distance.x) < 1 and abs(target_distance.z) < 0.25 and !in_attack and can_attack:
			in_attack = true
			can_attack = false
			stop_movement()
			await get_tree().create_timer(0.5).timeout
			in_attack = false
			await get_tree().create_timer(cooldown_attack).timeout
			can_attack = true
			speed = speed_default
		
		motion.x = x_direction * speed * delta
		motion.z = z_direction * speed * delta

func take_damage(damage_index: int, damage: int):
	if death:
		return
	
	take_damage_timer.stop()
	take_damage_index = damage_index
	take_damage_entry = true
	stop_movement()
	
	if take_damage_index >= 3:
		on_hit = true
		take_damage_timer.start()
		set_collision_layer_value(2, false)
	
	life = max(0, life - damage)
	animated_sprite.play("Hurt")
	ui_canvas.update_enemy_hud(enemy_name, life, life_default)
	
	if life <= 0:
		_death()
	else:
		take_damage_timer.start()

func _flip():
	if take_damage_entry or in_attack:
		return
	
	if player.transform.origin.x > transform.origin.x:
		facing_right = false
		$Attack/Spawn.position.x = -0.308
	else:
		facing_right = true
		$Attack/Spawn.position.x = 0.313
	
	animated_sprite.flip_h = not facing_right

func _animations():
	if take_damage_entry:
		return
	
	if in_attack:
		animated_sprite.play("Attack")
	else:
		if motion.x != 0 or motion.z != 0:
			animated_sprite.play("Walk")
		else:
			animated_sprite.play("Idle")

func _on_take_damage_timer_timeout():
	if take_damage_index >= 3:
		await get_tree().create_timer(1).timeout
		animated_sprite.play("Up")
		await get_tree().create_timer(1).timeout
		animated_sprite.play("Idle")
		set_collision_layer_value(2, true)
		restart_movement()
	else:
		restart_movement()

func _knockback():
	var direction = global_transform.origin.x - player.global_transform.origin.x
	knockback.x = direction.x * knockback_speed
	knockback.y = knockback_speed * 4
	move_and_collide(knockback)
	
	await get_tree().create_timer(0.3).timeout
	on_hit = false

func _death():
	stop_movement()
	death = true
	on_hit = true
	Global.score += 100
	animated_sprite.play("Down")
	set_collision_layer_value(2, false)
	await get_tree().create_timer(0.7).timeout
	
	for i in range(10):
		animated_sprite.visible = not animated_sprite.visible
		await get_tree().create_timer(0.1).timeout
	get_parent().enemy_death()
	queue_free()

func enemy_attack(value : int):
	var attk = ATTACK.instantiate()
	attk.strength = value
	get_parent().add_child(attk)
	attk.transform.origin = $Attack/Spawn.global_transform.origin

func stop_movement():
	speed = 0
	motion.x = 0
	motion.z = 0

func restart_movement():
	animated_sprite.play("Walk")
	speed = speed_default
	take_damage_entry = false
