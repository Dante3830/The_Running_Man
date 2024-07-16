extends CharacterBody3D

@export var speed = 5.0
@export var jump_force = 4.5

var can_hit = false
var combo : int

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
	
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_force
	
	if Input.is_action_just_pressed("Left"):
		sprite.flip_h = true
	elif Input.is_action_just_pressed("Right"):
		sprite.flip_h = false
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
	
	move_and_slide()

func _on_can_hit_timer_timeout() -> void:
	can_hit = true

func _on_combo_timer_timeout() -> void:
	combo = 0
	combo_text.hide()
