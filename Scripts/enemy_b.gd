extends CharacterBody3D

@export var speed = 5
@export var life = 3

var is_dead = false
var facing_right = false

var x_direction = 0.0
var z_direction = 0.0

@onready var animated_sprite = $AnimatedSprite3D
@onready var player = get_parent().get_node("Player1")

var walk_timer = 0.0

func _ready():
	randomize()

func _process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Move and slide
	move_and_slide()
	
	flip()
	
	if velocity.x != 0 or velocity.z != 0:
		animated_sprite.play("Walk")
	else:
		animated_sprite.play("Idle")

func _physics_process(delta):
	if !is_dead:
		var target_distance = player.transform.origin - transform.origin
		x_direction = target_distance.x / abs(target_distance.x)
		
		walk_timer += delta
		if walk_timer > randi() % 2 + 1:  # Cambiado para usar randi() correctamente
			z_direction = randi() % 3 - 1
			walk_timer = 0.0
		
		if abs(target_distance.x) < 1:
			x_direction = 0
		
		velocity.x = x_direction * speed
		velocity.z = z_direction * speed
	elif is_dead:
		queue_free()

func take_damage(damage_index: int, damage: int):
	life -= damage
	if life <= 0:
		is_dead = true

func flip():
	if player.transform.origin.x > transform.origin.x:
		facing_right = false
	else:
		facing_right = true
	
	animated_sprite.flip_h = not facing_right
