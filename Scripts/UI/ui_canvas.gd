extends CanvasLayer

@onready var player_1_health_bar = $UIGameplay/UIPlayers/Player1/HealthBar
@onready var player_2_health_bar = $UIGameplay/UIPlayers/Player2/HealthBar
@onready var player_1_lives = $UIGameplay/UIPlayers/Player1/P1LivesDP
@onready var player_2_lives = $UIGameplay/UIPlayers/Player2/P2LivesDP
@onready var player_2_section = $UIGameplay/UIPlayers/Player2

@onready var go_sign = $UIGameplay/GO
@onready var level_time_DP = $UIGameplay/LevelTimeDP

@onready var enemy_health_bar = $UIGameplay/UIEnemy/HealthBar
@onready var enemy_name_hud = $UIGameplay/UIEnemy/Name
@onready var enemy_section = $UIGameplay/UIEnemy
@onready var enemy_hud_timer = $EnemyHUDTimer

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
	level_time_DP.text = str(int(Global.level_time))
	
	update_player_1_hud()
	update_player_2_hud()

func update_player_1_hud():
	player_1_lives.text = "x " + str(Global.player_1_lives)
	
	if player_1_health_bar:
		player_1_health_bar.health = Global.player_1_health

func update_player_2_hud():
	player_1_lives.text = "x " + str(Global.player_2_lives)
	
	if player_2_health_bar:
		player_2_health_bar.health = Global.player_2_health

func update_enemy_hud(enemy_name : String, value : int, _max_value : int):
	if enemy_health_bar:
		enemy_health_bar.init_health(value)
		enemy_health_bar.health = value
		enemy_name_hud.text = enemy_name
		
		#enemy_hud_timer.stop()
		enemy_hud_timer.start()

func _on_enemy_hud_timer_timeout():
	enemy_section.hide()

func show_go_sign():
	$AnimationPlayer.play("go_animation")
