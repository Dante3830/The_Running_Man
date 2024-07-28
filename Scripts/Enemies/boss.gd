extends CharacterBody3D

const ATTACK = preload("res://Scenes/Enemies/EnemyAttack.tscn")

# Velocidad
@export var speed_default = 2.0
@export var cooldown_attack = 1.0

# Vida
@export var life_default = 200

@export var fall_duration = 2.0

var death = false
var facing_right = false
var take_damage_entry = false

var in_attack = false
var can_attack = true

var on_hit = false

var motion : Vector3
var knockback : Vector3

var knockback_speed = 0.5

var take_damage_index = 0

var walk_timer = 0.0

var x_direction = 0.0
var z_direction = 0.0

@onready var speed = speed_default
@onready var life = life_default
@onready var sprite = $Sprite3D
@onready var take_damage_timer = $TakeDamageTimer
@onready var animation_player = $AnimationPlayer
@onready var ui_canvas = get_parent().get_node("UICanvas")

@onready var detection_area = $Detection
@onready var player = null

@export var attk_distance_x = 0.5
@export var attk_distance_z = 0.5

var target_1 = null
var target_2 = null

func _process(delta):
	_update_targets()
	_check_gravity_activation(delta)
	_movement(delta)
	_animations()
	_flip()

func _update_targets():
	if Global.player_1_name == "Richard" or Global.player_1_name == "Amber":
		target_1 = get_parent().get_node(Global.player_1_name)
	else:
		target_1 = null
	
	if Global.two_players_mode:
		if Global.player_2_name == "Richard" or Global.player_2_name == "Amber":
			target_2 = get_parent().get_node(Global.player_2_name)
		else:
			target_2 = null
	else:
		target_2 = null

func _check_gravity_activation(delta):
	var should_activate_gravity = false
	
	if target_1 and target_1.global_transform.origin.x >= 17.0:
		should_activate_gravity = true
	elif Global.two_players_mode and target_2 and target_2.global_transform.origin.x >= 17.0:
		should_activate_gravity = true
	
	if should_activate_gravity:
		velocity.y -= 9.8 * delta
	else:
		velocity.y = 0

func _physics_process(delta):
	if not death and not on_hit:
		_movement(delta)
	elif on_hit:
		_knockback()

func _movement(_delta):
	if take_damage_entry or death:
		return
	
	if player and not take_damage_entry:
		var direction = (player.global_position - global_position).normalized()
		var distance = global_position.distance_to(player.global_position)
		var distance_x = abs(player.global_position.x - global_position.x)
		var distance_z = abs(player.global_position.z - global_position.z)
		var stop_distance = max(attk_distance_x, attk_distance_z)
		
		if not in_attack:
			if distance > stop_distance:
				# Moverse hacia el jugador
				velocity.x = direction.x * speed_default
				velocity.z = direction.z * speed_default
			else:
				# Detenerse cerca del jugador
				stop_movement()
			
			# Atacar cuando esté lo suficientemente cerca en ambos ejes
			if distance_x <= attk_distance_x and distance_z <= attk_distance_z and can_attack:
				_start_attack()
		else:
			stop_movement()
	else:
		stop_movement()
	
	# Mover al enemigo
	move_and_slide()

func take_damage(damage_index: int, damage: int):
	if death:
		return
	
	take_damage_timer.stop()
	take_damage_index += damage_index
	take_damage_entry = true
	stop_movement()
	
	life = max(0, life - damage)
	ui_canvas.update_enemy_hud("Frost", life, life_default)
	
	if take_damage_index >= 6:
		on_hit = true
		animation_player.play("Down")
		set_collision_layer_value(2, false)
		get_tree().create_timer(fall_duration).timeout.connect(_get_up)
	else:
		animation_player.play("Hurt")
		take_damage_timer.start()
	
	if life <= 0:
		_death()

func _flip():
	if take_damage_entry or in_attack:
		return
	
	if target_1.transform.origin.x > transform.origin.x:
		facing_right = true
		$Attack/Spawn.position.x = 0.512
	else:
		facing_right = false
		$Attack/Spawn.position.x = -0.512
	
	sprite.flip_h = not facing_right

func _animations():
	if take_damage_entry:
		return
	
	if in_attack:
		animation_player.play("Attack")
	else:
		if velocity.length() > 0.0:
			animation_player.play("Walk")
		else:
			animation_player.play("Idle")

func stop_movement():
	velocity.x = 0
	velocity.z = 0

func restart_movement():
	animation_player.play("Walk")
	speed = speed_default
	take_damage_entry = false

func _knockback():
	var direction = global_transform.origin.x - player.global_transform.origin.x
	knockback.x = direction * knockback_speed
	knockback.y = knockback_speed * 4
	move_and_slide()
	
	await get_tree().create_timer(0.3).timeout
	on_hit = false

func _death():
	stop_movement()
	death = true
	on_hit = true
	Global.score += 10000
	animation_player.play("Death")
	set_collision_layer_value(2, false)

func enemy_attack(value : int):
	var attk = ATTACK.instantiate()
	attk.strength = value
	get_parent().add_child(attk)
	attk.transform.origin = $Attack/Spawn.global_transform.origin

func _on_take_damage_timer_timeout():
	restart_movement()

func _on_death_animation_finished(anim_name: StringName):
	if anim_name == "Death":
		queue_free()

func _on_detection_body_entered(body):
	if body.get_collision_layer() == 1:
		player = body

func _on_detection_body_exited(body):
	if body.get_collision_layer() == 1:
		player = null

func _get_up():
	animation_player.play("Up")
	await animation_player.animation_finished
	animation_player.play("Idle")
	set_collision_layer_value(2, true)
	take_damage_index = 0
	on_hit = false
	restart_movement()

func _start_attack():
	in_attack = true
	can_attack = false
	stop_movement()
	get_tree().create_timer(0.5).timeout.connect(_end_attack)

func _end_attack():
	in_attack = false
	get_tree().create_timer(cooldown_attack).timeout.connect(_reset_attack)

func _reset_attack():
	can_attack = true
