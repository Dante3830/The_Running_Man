extends CanvasLayer

# Jugador 1
@onready var player_1_health_bar = $UIGameplay/UIPlayers/Player1/HealthBar
@onready var player_1_lives_DP = $UIGameplay/UIPlayers/Player1/P1LivesDP
@onready var player_1_name_DP = $UIGameplay/UIPlayers/Player1/P1Name
@onready var player_1_health_int = $UIGameplay/UIPlayers/Player1/P1Health

# Jugador 2
@onready var player_2_health_bar = $UIGameplay/UIPlayers/Player2/HealthBar
@onready var player_2_lives_DP = $UIGameplay/UIPlayers/Player2/P2LivesDP
@onready var player_2_name_DP = $UIGameplay/UIPlayers/Player2/P2Name
@onready var player_2_health_int = $UIGameplay/UIPlayers/Player2/P2Health

@onready var player_2_section = $UIGameplay/UIPlayers/Player2

# Enemigos
@onready var enemy_health_bar = $UIGameplay/UIEnemy/HealthBar
@onready var enemy_name_hud = $UIGameplay/UIEnemy/Name
@onready var enemy_section = $UIGameplay/UIEnemy
@onready var enemy_health_int = $UIGameplay/UIEnemy/EnemyHealth
@onready var enemy_hud_timer = $EnemyHUDTimer

# Nivel
@onready var go_sign = $UIGameplay/GO
@onready var level_time_DP = $UIGameplay/UITime/LevelTimeDP
@onready var time_up = $UIGameplay/UITime/TimeUp
@onready var score_DP = $UIGameplay/ScoreDP

func _ready():
	if !Global.two_players_mode:
		player_2_section.hide()
	else:
		player_2_section.show()
	
	enemy_section.hide()
	go_sign.hide()
	
	if player_1_health_bar:
		player_1_health_bar.init_health(Global.player_1_health)
	
	if player_2_health_bar:
		player_2_health_bar.init_health(Global.player_2_health)

func _process(_delta):
	score_DP.text = "SCORE: " + str(Global.score)
	
	player_1_health_int.text = str(Global.player_1_health)
	player_2_health_int.text = str(Global.player_2_health)
	
	update_time_hud()
	update_player_1_hud()
	update_player_2_hud()

func recreate_player_health_bar(player_number: int):
	var ui_players = $UIGameplay/UIPlayers
	var player_section = ui_players.get_node("Player" + str(player_number))
	
	var old_health_bar = player_section.get_node_or_null("HealthBar")
	if old_health_bar:
		old_health_bar.queue_free()
	
	var new_health_bar = preload("res://Scenes/UI/HealthBar.tscn").instantiate()
	player_section.add_child(new_health_bar)
	new_health_bar.name = "HealthBar"
	
	new_health_bar.init_health(Global.get("player_{n}_health".format({"n": player_number})))
	
	if player_number == 1:
		new_health_bar.custom_minimum_size = Vector2(240, 25)  
		new_health_bar.rotation_degrees = 0  
		new_health_bar.position = Vector2(66, 81)  
	else:
		new_health_bar.custom_minimum_size = Vector2(240, 25)  
		new_health_bar.rotation_degrees = 180  
		new_health_bar.position = Vector2(539, 131)  
	
	if player_number == 1:
		player_1_health_bar = new_health_bar
	else:
		player_2_health_bar = new_health_bar

func recreate_enemy_health_bar():
	var old_health_bar = $UIGameplay/UIEnemy/HealthBar
	if old_health_bar:
		old_health_bar.queue_free()
	
	var new_health_bar = preload("res://Scenes/UI/HealthBar.tscn").instantiate()
	$UIGameplay/UIEnemy.add_child(new_health_bar)
	new_health_bar.name = "HealthBar"
	
	new_health_bar.init_health(100)
	
	new_health_bar.custom_minimum_size = Vector2(240, 25)
	new_health_bar.rotation_degrees = 0
	new_health_bar.position = Vector2(66, 81)
	
	enemy_health_bar = new_health_bar

func get_player_health_bar_properties(player_number: int) -> Dictionary:
	var health_bar = player_1_health_bar if player_number == 1 else player_2_health_bar
	if is_instance_valid(health_bar):
		return {
			"size": health_bar.custom_minimum_size,
			"rotation": health_bar.rotation_degrees,
			"position": health_bar.position
		}
	return {}

func set_player_health_bar_properties(player_number: int, properties: Dictionary):
	var health_bar = player_1_health_bar if player_number == 1 else player_2_health_bar
	if is_instance_valid(health_bar):
		if "size" in properties:
			health_bar.custom_minimum_size = properties["size"]
		if "rotation" in properties:
			health_bar.rotation_degrees = properties["rotation"]
		if "position" in properties:
			health_bar.position = properties["position"]

func get_enemy_health_bar_properties() -> Dictionary:
	if is_instance_valid(enemy_health_bar):
		return {
			"size": enemy_health_bar.custom_minimum_size,
			"rotation": enemy_health_bar.rotation_degrees,
			"position": enemy_health_bar.position
		}
	return {}

func set_enemy_health_bar_properties(properties: Dictionary):
	if is_instance_valid(enemy_health_bar):
		if "size" in properties:
			enemy_health_bar.custom_minimum_size = properties["size"]
		if "rotation" in properties:
			enemy_health_bar.rotation_degrees = properties["rotation"]
		if "position" in properties:
			enemy_health_bar.position = properties["position"]

func update_player_1_hud():
	player_1_name_DP.text = Global.player_1_name
	player_1_lives_DP.text = "x " + str(Global.player_1_lives)
	
	if is_instance_valid(player_1_health_bar):
		player_1_health_bar.health = Global.player_1_health
	else:
		recreate_player_health_bar(1)
	
	if is_instance_valid(player_1_health_bar):
		player_1_health_bar.health = Global.player_1_health
	else:
		player_1_health_bar = $UIGameplay/UIPlayers/Player1/HealthBar
		if is_instance_valid(player_1_health_bar):
			player_1_health_bar.init_health(Global.player_1_health)

func update_player_2_hud():
	player_2_name_DP.text = Global.player_2_name
	player_2_lives_DP.text = "x " + str(Global.player_2_lives)
	
	if is_instance_valid(player_2_health_bar):
		player_2_health_bar.health = Global.player_2_health
	else:
		recreate_player_health_bar(2)
	
	if is_instance_valid(player_2_health_bar):
		player_2_health_bar.health = Global.player_2_health
	else:
		player_2_health_bar = $UIGameplay/UIPlayers/Player2/HealthBar
		if is_instance_valid(player_2_health_bar):
			player_2_health_bar.init_health(Global.player_2_health)

func update_enemy_hud(enemy_name: String, value: int, max_value: int, is_boss: bool = false):
	if not is_instance_valid(enemy_health_bar):
		recreate_enemy_health_bar()
	
	enemy_health_int.text = str(value)
	
	if enemy_health_bar and is_instance_valid(enemy_health_bar):
		enemy_health_bar.init_health(max_value)
		enemy_health_bar.health = value
		enemy_name_hud.text = enemy_name
		
		if is_boss:
			enemy_health_bar.custom_minimum_size = Vector2(400, 25)
		else:
			enemy_health_bar.custom_minimum_size = Vector2(240, 25)
		
		enemy_section.show()
		enemy_hud_timer.stop()
		enemy_hud_timer.start()
	else:
		print("Error: enemy_health_bar is not valid")

func _on_enemy_hud_timer_timeout():
	enemy_section.hide()

func update_time_hud():
	if Global.level_time > 9:
		level_time_DP.text = str(int(Global.level_time))
	else:
		level_time_DP.text = "0" + str(int(Global.level_time))
	
	if Global.is_time_up or Global.level_time <= 0:
		time_up.show()
	else:
		time_up.hide()

func show_go_sign():
	$AnimationPlayer.play("go_animation")
