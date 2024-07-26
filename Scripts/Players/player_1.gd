extends CharacterBody3D

const ATTACK = preload("res://Scenes/Players/PlayerAttack.tscn")

@export var speed = 5.0
@export var jump_force = 4.5

var combo : int
var hitting = false
var is_dead = false
var attack_index = -1
var attack = ["hit1", "hit2", "hit3"]

var in_attack = false
var can_hit = true

var in_take_damage = false
var motion : Vector3

@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite3D
@onready var jump_sprite = $JumpSprite
@onready var hit_timer = $CanHitTimer

@onready var state_machine = $AnimationTree.get("parameters/playback")

@onready var ui_canvas = get_parent().get_node("UICanvas")
@onready var camera = get_parent().get_node("Camera")

signal player_died(player)

func _process(_delta):
	print("Posición del jugador: ", global_position)
	transform.origin.x = clamp(transform.origin.x, camera.transform.origin.x - 4.5, camera.clamped + 4.5)

func _physics_process(delta):
	if in_take_damage:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		jump_sprite.visible = true
		sprite.visible = false
	else:
		jump_sprite.visible = false
		sprite.visible = true
	
	if Input.is_action_just_pressed("Left"):
		sprite.flip_h = true
		jump_sprite.flip_h = false
		$Attack/Spawn.position.x = -0.4
	elif Input.is_action_just_pressed("Right"):
		sprite.flip_h = false
		jump_sprite.flip_h = true
		$Attack/Spawn.position.x = 0.4
	
	# Movimiento
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		state_machine.travel("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		state_machine.travel("Idle")
	
	# Salto
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_force
	
	if Input.is_action_pressed("Hit"):
		hitting = true
		state_machine.travel("Hit1")
		attack_index = (attack_index + 1) % attack.size()
		
		if attack_index > 3:
			attack_index = 0
	
	move_and_slide()

func player_attack(damage_index : int, damage : int):
	if in_take_damage:
		return
	
	var attk = ATTACK.instantiate()
	attk.index = damage_index
	attk.strength = damage
	get_parent().add_child(attk)
	attk.transform.origin = get_node("Attack/Spawn").global_transform.origin

func take_damage(damage: int):
	if is_dead:
		return
	
	Global.player_1_health -= damage
	state_machine.travel("Hurt")
	ui_canvas.update_player_1_hud()
	
	if Global.player_1_health <= 0:
		_death()
	else:
		in_take_damage = true
		await get_tree().create_timer(0.2).timeout
		in_take_damage = false

func _on_can_hit_timer_timeout():
	can_hit = true

func _on_combo_timer_timeout():
	combo = 0

func stop_movement():
	speed = 0
	motion.x = 0
	motion.z = 0

func _death():
	stop_movement()
	is_dead = true
	Global.player_1_lives -= 1
	state_machine.travel("Death")  # Asumiendo que tienes una animación de muerte
	
	# Emitir señal de muerte
	emit_signal("player_died", self)
	
	# Esperar a que termine la animación de muerte
	#await animation.animation_finished
	
	# Auto-destruirse
	queue_free()

func respawn():
	Global.player_1_health = 100
	is_dead = false
	in_take_damage = false
	ui_canvas.update_player_1_hud()
	state_machine.travel("Idle")
