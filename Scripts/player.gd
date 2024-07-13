extends CharacterBody2D

@export var speed = 300.0

@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var health_bar = $CanvasLayer/HealthBar
@onready var hit_timer = $CanHitTimer
@onready var combo_text = $CanvasLayer/ComboDP
@onready var combo_timer = $ComboTimer  # Agregar un temporizador para el combo
@onready var lives_text = $CanvasLayer/LivesDP

var combo : int
var punch = false

# Indica que el jugador puede golpear
var can_hit = true 

# Añadir posición de respawn
var respawn_position : Vector2

# Añadir variable para controlar si el jugador ya ha sido "muerto"
var is_dead = false

@onready var state_machine = $AnimationTree.get("parameters/playback")

func _ready():
	if health_bar:
		health_bar.init_health(Global.player_1_health)
	visible = true
	# Establecer la posición de respawn inicial
	respawn_position = global_position
	# Ocultar el texto del combo al inicio
	combo_text.hide()

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
	
	if directionX != 0 or directionY != 0:
		velocity.x = directionX * speed
		velocity.y = directionY * speed
		state_machine.travel("Walk")
	else:
		velocity = Vector2.ZERO
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
		show_combo_text()

	# Golpe izquierdo
	elif Input.is_action_just_pressed("Hit") and sprite.flip_h and can_hit:
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
		show_combo_text()

func show_combo_text():
	if combo >= 2:
		combo_text.text = str(combo) + " golpes"
		combo_text.show()
		combo_timer.start()

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
