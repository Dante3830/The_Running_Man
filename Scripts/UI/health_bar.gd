# HEALTH BAR
extends ProgressBar

@onready var damage_bar = $DamageBar
@onready var timer = $Timer

var health = 0 : set = set_health

func set_health(new_health):
	var prev_health = health
	health = clamp(new_health, 0, max_value)
	value = health
	
	if health <= 0:
		queue_free()
	
	if health < prev_health:
		timer.start()
	else:
		damage_bar.value = health

func init_health(_heatlh):
	health = _heatlh
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health

func _on_timer_timeout():
	damage_bar.value = health
