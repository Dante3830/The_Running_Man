extends CharacterBody2D

var life = 3
var target = null
const SPEED = 100
var animation = false
var punch = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var health_bar = $HealthBar
@onready var hit_timer = $HitTimer

func hurt():
	if life > 0:
		animation = true
		animated_sprite.play("hurt")
		print("hurt")

func _on_animated_sprite_2d_animation_finished():
	if life == 0:
		animation = true
		animated_sprite.play("knockout")
		$KOTimer.start()
	else:
		animation = false
		animated_sprite.play("idle")

func _ready():
	if health_bar:
		health_bar.init_health(life)

func _physics_process(delta):
	if health_bar:
		health_bar.health = life
	
	if life > 0 and target:
		velocity = global_position.direction_to(target.global_position)
		move_and_collide(velocity * SPEED * delta)
		if animation == false:
			animated_sprite.play("walk")
			
		if global_position.x >= target.global_position.x:
			animated_sprite.flip_h = false
		if global_position.x <= target.global_position.x:
			animated_sprite.flip_h = true
	
	hitting()

func hitting():
	for body in $LeftPunch.get_overlapping_bodies():
		if body.get_collision_layer() == 1:
			if punch == false:
				animation = true
				punch = true
				hit_timer.start()
				animated_sprite.play("hit")
				body._hurt()
				Global.player_1_health -= 1
				print("Player: " + str(Global.player_1_health))
	
	for body in $RightPunch.get_overlapping_bodies():
		if body.get_collision_layer() == 1:
			if punch == false:
				animation = true
				punch = true
				hit_timer.start()
				animated_sprite.play("hit")
				body._hurt()
				Global.player_1_health -= 1
				print("Player: " + str(Global.player_1_health))

func _on_detection_area_body_entered(body):
	print(body.name)
	if body.name == "Player":
		target = body

func _on_detection_area_body_exited(body):
	if body.name == "Player":
		target = null

func _on_ko_timer_timeout():
	queue_free()

func _on_hit_timer_timeout():
	punch = false
	animation = false
