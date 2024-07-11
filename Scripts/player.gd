# JUGADOR
extends CharacterBody2D

@export var speed = 300.0
@export var hit_cooldown = 0.5  # Añadido: tiempo de enfriamiento para golpes

@onready var animated_sprite = $AnimatedSprite2D
@onready var health_bar = $CanvasLayer/HealthBar

var punch = false
var hurt = false
var can_hit = true  # Añadido: indicador para permitir golpear

func _ready():
	health_bar.init_health(Global.player_1_health)

func _process(_delta):
	health_bar.health = Global.player_1_health
	
	if Input.is_action_just_pressed("Left"):
		animated_sprite.flip_h = true
	elif Input.is_action_just_pressed("Right"):
		animated_sprite.flip_h = false
	
	var directionX := Input.get_axis("Left", "Right")
	var directionY := Input.get_axis("Up", "Down")
	
	if directionX != 0 or directionY != 0:
		velocity.x = directionX * speed
		velocity.y = directionY * speed
		animated_sprite.play("walk")
	else:
		velocity = Vector2.ZERO
		animated_sprite.play("idle")
	
	move_and_slide()
	
	# Golpe derecho
	if Input.is_action_just_pressed("Hit") and !animated_sprite.flip_h and can_hit:
		animated_sprite.play("hit")
		for body in $RightHit.get_overlapping_bodies():
			if body.get_collision_layer() == 2:
				body.hurt()
				body.life -= 1
				print("Enemy: " + str(body.life))
		can_hit = false
	$HitTimer.start()
	
	# Golpe izquierdo
	if Input.is_action_just_pressed("Hit") and animated_sprite.flip_h and can_hit:
		animated_sprite.play("hit")
		for body in $LeftHit.get_overlapping_bodies():
			if body.get_collision_layer() == 2:
				body.hurt()
				body.life -= 1
				print("Enemy: " + str(body.life))
		can_hit = false

func _on_hit_timer_timeout():
	can_hit = true

func _on_animated_sprite_2d_animation_finished():
	if Global.player_1_health == 0:
		get_tree().quit()
	else:
		animated_sprite.play("idle")
		punch = false
		hurt = false

func _hurt():
	hurt = true
	punch = true
	animated_sprite.play("hurt")
