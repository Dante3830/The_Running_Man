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
@onready var sprite = $Sprite3D
@onready var animation_player = $AnimationPlayer

@onready var take_damage_timer = $TakeDamageTimer
@onready var ui_canvas = get_parent().get_node("UICanvas")

@onready var detection_area = $Detection
@onready var player = null

@export var attk_distance_x = 0.5  # Distancia en X para atacar
@export var attk_distance_z = 0.5  # Distancia en Z para atacar

func _on_detection_body_entered(body):
	if body.get_collision_layer() == 1:
		player = body
		print("Jugador detectado")

func _on_detection_body_exited(body):
	if body.get_collision_layer() == 1:
		player = null
		print("Jugador salió del rango")

func _process(delta):
	# Gravedad
	motion.y -= 9.8 * delta
	
	# Si no hay nada, se pone el nombre por defecto
	if enemy_name == "":
		enemy_name = "Jim"
	
	_animations()
	_flip()

func _physics_process(delta):
	if not death and not on_hit:
		_movement(delta)
	elif on_hit:
		_knockback()

func _movement(delta):
	if take_damage_entry or death:
		return
	
	if player:
		var direction = (player.global_position - global_position).normalized()
		var distance_x = abs(player.global_position.x - global_position.x)
		var distance_z = abs(player.global_position.z - global_position.z)
		
		if not in_attack:
			# Moverse hacia el jugador
			motion.x = direction.x * speed * delta
			motion.z = direction.z * speed * delta
		else:
			# Detener movimiento durante el ataque
			motion.x = 0
			motion.z = 0
		
		# Activar ataque cuando esté alineado en Z y cerca en X
		if distance_x <= attk_distance_x and distance_z <= player.global_position.z and can_attack:
			_start_attack()
		
		# Actualizar direcciones para animación
		x_direction = sign(motion.x)
		z_direction = sign(motion.z)
	else:
		# Si no hay jugador, detener el movimiento
		motion.x = 0
		motion.z = 0
	
	print("Posición del enemigo: ", global_position)
	
	# Mover al enemigo
	move_and_slide()

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
	animation_player.play("Hurt")
	ui_canvas.update_enemy_hud(enemy_name, life, life_default)
	
	if life <= 0:
		_death()
	else:
		take_damage_timer.start()

func _flip():
	if take_damage_entry or in_attack:
		return
	
	if player and player.transform.origin.x > transform.origin.x:
		facing_right = false
		$Attack/Spawn.position.x = 0.308
	else:
		facing_right = true
		$Attack/Spawn.position.x = -0.313
	
	sprite.flip_h = not facing_right

func _animations():
	if take_damage_entry:
		return
	
	if in_attack:
		animation_player.play("Attack")
	else:
		if motion.x != 0 or motion.z != 0:
			animation_player.play("Walk")
		else:
			animation_player.play("Idle")

func _on_take_damage_timer_timeout():
	if take_damage_index >= 3:
		await get_tree().create_timer(1).timeout
		animation_player.play("Up")
		await get_tree().create_timer(1).timeout
		animation_player.play("Idle")
		set_collision_layer_value(2, true)
		restart_movement()
	else:
		restart_movement()

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
	Global.score += 100
	animation_player.play("Down")
	set_collision_layer_value(2, false)
	await get_tree().create_timer(0.7).timeout
	
	for i in range(10):
		sprite.visible = not sprite.visible
		await get_tree().create_timer(0.1).timeout
	ui_canvas.update_enemy_hud("", 0, 0)
	get_parent().enemy_death()
	queue_free()

func enemy_attack(value : int):
	var attk = ATTACK.instantiate()
	attk.strength = value
	get_parent().add_child(attk)
	attk.transform.origin = $Attack/Spawn.global_transform.origin

func stop_movement():
	motion.x = 0
	motion.z = 0

func restart_movement():
	animation_player.play("Walk")
	speed = speed_default
	take_damage_entry = false

func _start_attack():
	in_attack = true
	can_attack = false
	stop_movement()
	# Aquí podrías llamar a la función de ataque si es necesario
	get_tree().create_timer(0.5).timeout.connect(_end_attack)

func _end_attack():
	in_attack = false
	get_tree().create_timer(cooldown_attack).timeout.connect(_reset_attack)

func _reset_attack():
	can_attack = true
