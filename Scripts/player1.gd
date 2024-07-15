extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var can_hit = false
var combo : int

@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite3D
@onready var health_bar = $CanvasLayer/HealthBar
@onready var hit_timer = $CanHitTimer
@onready var combo_text = $CanvasLayer/ComboDP
@onready var lives_text = $CanvasLayer/LivesDP

@onready var state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()


func _on_can_hit_timer_timeout() -> void:
	can_hit = true

func _on_combo_timer_timeout() -> void:
	combo = 0
	combo_text.hide()
