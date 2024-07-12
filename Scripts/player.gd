extends CharacterBody2D

@export var speed = 300.0
@export var jump_force = 400.0  # Fuerza del salto
@export var gravity = 800.0  # Gravedad aplicada al jugador

@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var health_bar = $CanvasLayer/HealthBar
@onready var hit_timer = $CanHitTimer
@onready var combo_text = $CanvasLayer/ComboDP
@onready var lives_text = $CanvasLayer/LivesDP

var combo : int
var punch = false

var can_hit = true # Indica que el jugador puede golpear

@onready var state_machine = $AnimationTree.get("parameters/playback")

func _ready():
	health_bar.init_health(Global.player_1_health)
	visible = true

func _process(_delta):
	#if combo >= 2:
		#combo_text.show()
		#combo_text.text = str(combo) + " golpes"
	lives_text.text = "x " + str(Global.player_1_lives)

func _physics_process(_delta):
	health_bar.health = Global.player_1_health
	
	# Movimiento basico
	if Input.is_action_just_pressed("Left"):
		sprite.flip_h = true
	elif Input.is_action_just_pressed("Right"):
		sprite.flip_h = false
	
	var directionX = Input.get_axis("Left", "Right")
	var directionY = Input.get_axis("Up", "Down")
	
	velocity.x = directionX * speed
	velocity.y = directionY * speed
	
	# Salto
	if not is_on_floor():
		velocity.y += gravity * _delta  # Aplicar gravedad
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = -jump_force  # Aplicar fuerza del salto
	
	if directionX != 0 or directionY != 0:
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
	
	move_and_slide()
	
	hitting()

func hitting():
	# Golpe derecho
	if Input.is_action_just_pressed("Hit") and !sprite.flip_h and can_hit:
		if combo == 0:
			state_machine.travel("Hit1")
		elif combo == 1:
			state_machine.travel("Hit2")
		elif combo == 2:
			state_machine.travel("Hit3")
		elif combo == 3:
			state_machine.travel("Kick")
		combo += 1
		punch = true
		for body in $RightHit.get_overlapping_bodies():
			if body.get_collision_layer() == 2:
				body.hurt()
				body.life -= 1
				print("Enemy: " + str(body.life))
				print("GOLPE")
		can_hit = false
		hit_timer.start()
	
	# Golpe izquierdo
	elif Input.is_action_just_pressed("Hit") and sprite.flip_h and can_hit:  # Usar elif aquí para evitar doble golpe en un mismo frame
		if combo == 0:
			state_machine.travel("Hit1")
		elif combo == 1:
			state_machine.travel("Hit2")
		elif combo == 2:
			state_machine.travel("Hit3")
		elif combo == 3:
			state_machine.travel("Kick")
		combo += 1
		punch = true
		for body in $LeftHit.get_overlapping_bodies():
			if body.get_collision_layer() == 2:
				body.hurt()
				body.life -= 1
				print("Enemy: " + str(body.life))
				print("GOLPE")
		can_hit = false
		hit_timer.start()

func _hurt():
	if Global.player_1_health == 0:
		Global.player_1_lives -= 1
		queue_free()
	state_machine.travel("Hurt")

func _on_can_hit_timer_timeout():
	can_hit = true

func _on_combo_timer_timeout():
	combo = 0
	combo_text.hide()
