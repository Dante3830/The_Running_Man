extends CharacterBody3D

const ATTACK = preload("res://Scenes/Players/PlayerAttack.tscn")

@export var speed = 5.0
@export var jump_force = 4.5

var can_hit = false
var combo : int
var hitting = false
var is_dead = false
var attack_index = -1
var attack = ["hit1", "hit2", "hit3"]

@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite3D
@onready var health_bar = $CanvasLayer/HealthBar
@onready var hit_timer = $CanHitTimer
@onready var combo_text = $CanvasLayer/ComboDP
@onready var lives_text = $CanvasLayer/LivesDP

@onready var state_machine = $AnimationTree.get("parameters/playback")

func _ready():
	if health_bar:
		health_bar.init_health(Global.player_1_health)

func _process(_delta):
	lives_text.text = "x " + str(Global.player_1_lives)

func _physics_process(delta):
	if health_bar:
		health_bar.health = Global.player_1_health
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("Left"):
		sprite.flip_h = true
	elif Input.is_action_just_pressed("Right"):
		sprite.flip_h = false
	
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
	
	move_and_slide()

func player_attack(damage_index : int, damage : int):
	var attk = ATTACK.instantiate()
	attk.index = damage_index
	attk.strength = damage
	get_parent().add_child(attk)
	attk.transform.origin = get_node("Attack/Spawn").global_transform.origin

func take_damage():
	Global.player_1_health -= 1
	if Global.player_1_health <= 0 and not is_dead:
		is_dead = true
		Global.player_1_health = 0
		queue_free()
	state_machine.travel("Hurt")

func _on_can_hit_timer_timeout():
	can_hit = true

func _on_combo_timer_timeout():
	combo = 0
	combo_text.hide()
