extends CharacterBody2D

@export var speed = 300.0
@export var jump_force = 400.0  # Fuerza del salto
@export var gravity = 800.0  # Gravedad aplicada al jugador
@export var min_y_limit = 650.0
@export var max_y_limit = 950.0

@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var health_bar = $CanvasLayer/HealthBar
@onready var hit_timer = $CanHitTimer
@onready var combo_text = $CanvasLayer/ComboDP
@onready var lives_text = $CanvasLayer/LivesDP

var combo : int
var punch = false

# Indica que el jugador puede golpear
var can_hit = true 

# Añadir posición de respawn
var respawn_position : Vector2

# Añadir variable para controlar si el jugador ya ha sido "muerto"
var is_dead = false

# Variable para controlar si el jugador está en el aire
var is_jumping = false  # Indica si el jugador está en el aire

@onready var state_machine = $AnimationTree.get("parameters/playback")

func _ready():
	if health_bar:
		health_bar.init_health(Global.player_1_health)
	visible = true
	# Establecer la posición de respawn inicial
	respawn_position = global_position

func _process(_delta):
	lives_text.text = "x " + str(Global.player_1_lives)

func _physics_process(_delta):
	if health_bar:
		health_bar.health = Global.player_1_health
	
	if Input.is_action_just_pressed("Left"):
		sprite.flip_h = true
	elif Input.is_action_just_pressed("Right"):
		sprite.flip_h = false
	
	var directionX = Input.get_axis("Left", "Right")
	var directionY = Input.get_axis("Up", "Down")
	
	velocity.x = directionX * speed

	if is_jumping:
		velocity.y += gravity * _delta  # Aplicar gravedad si el jugador está saltando

	if Input.is_action_just_pressed("Jump") and not is_jumping:
		velocity.y = -jump_force  # Aplicar fuerza del salto
		is_jumping = true

	# Simular que hay un piso en una posición Y específica
	if global_position.y >= max_y_limit:
		global_position.y = max_y_limit
		velocity.y = 0
		is_jumping = false

	if directionX != 0 or directionY != 0:
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

	# Limites en el eje Y
	if global_position.y < min_y_limit:
		global_position.y = min_y_limit
	elif global_position.y > max_y_limit:
		global_position.y = max_y_limit
	
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

# Añadir función para establecer la posición de respawn
func set_respawn_position():
	respawn_position = global_position

# Función para reaparecer
func respawn():
	global_position = respawn_position
	Global.player_1_health = 10 # Reiniciar la salud del jugador
	is_dead = false # Resetear la bandera is_dead
	visible = true
