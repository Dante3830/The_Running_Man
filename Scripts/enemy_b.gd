extends CharacterBody3D

# Velocidad
@export var speed_default = 1

# Vida
@export var life_default = 100

var death = false
var facing_right = false
var take_damage_entry = false

var on_hit = false

var motion : Vector3
var knockback : Vector3

var knockback_speed = 0.5

var take_damage_index = 0

var walk_timer = 0.0

var x_direction = 0.0
var z_direction = 0.0

var speed = speed_default
var life = life_default
@onready var animated_sprite = $AnimatedSprite3D
@onready var player = get_parent().get_node("Player1")
@onready var take_damage_timer = $TakeDamageTimer

func _ready():
	randomize()

func _process(delta):
	# Gravedad
	motion.y -= 9.8 * delta
	
	_movement(delta)
	_animations()
	_flip()

func _physics_process(delta):
	if death and on_hit or on_hit:
		_knockback()
	motion = Vector3(x_direction, motion.y, z_direction) * speed * delta

func _movement(delta):
	
	if take_damage_entry:
		return
	
	if !death:
		var target_distance = player.transform.origin - transform.origin
		x_direction = target_distance.x / abs(target_distance.x)
		
		walk_timer += delta
		if walk_timer > randi() % 2 + 1:
			z_direction = randi() % 3 - 1
			walk_timer = 0.0
		
		if abs(target_distance.x) < 1:
			x_direction = 0
		
		motion = Vector3(x_direction, motion.y, z_direction) * speed * delta

func take_damage(damage_index: int, damage: int):
	if death:
		return
	
	take_damage_timer.start()
	take_damage_index = damage_index
	take_damage_entry = true
	stop_movement()
	
	if take_damage_index >= 3:
		on_hit = true
		take_damage_timer.start()
	
	life -= damage
	animated_sprite.play("Hurt")
	
	if life <= 0:
		_death()

func _flip():
	if take_damage_entry:
		return
	
	if player.transform.origin.x > transform.origin.x:
		facing_right = false
	else:
		facing_right = true
	
	animated_sprite.flip_h = not facing_right

func _animations():
	if take_damage_entry:
		return
	
	if motion.x != 0 or motion.z != 0:
		animated_sprite.play("Walk")
	else:
		animated_sprite.play("Idle")

func stop_movement():
	speed = 0
	motion.x = 0
	motion.z = 0

func restart_movement():
	animated_sprite.play("Walk")
	speed = speed_default
	take_damage_entry = false

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
	var direction = (global_transform.origin - player.global_transform.origin).normalized()
	knockback.x = direction.x * knockback_speed
	knockback.y = knockback_speed * 4
	global_transform.origin += knockback * get_physics_process_delta_time()

func _death():
	death = true
	on_hit = true
	animated_sprite.play("Down")
	set_collision_layer_value(2, false)
	await get_tree().create_timer(0.7).timeout
	
	for i in range(10):
		animated_sprite.visible = not animated_sprite.visible
		await get_tree().create_timer(0.1).timeout
	queue_free()
