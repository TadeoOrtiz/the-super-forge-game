class_name Room
extends TileMap

const PLAYER: PackedScene = preload ("res://nodes/player.tscn")
const ENEMY_SPAWENER: PackedScene = preload ("res://nodes/enemy_spawner.tscn")

@export var max_round: int
@export var time_per_round: int
@export var round_time: int

@export var spawn: Array[SpawnInfo]
@export var max_enemy_counter: int = 100

@export_category("DEBUG")
@export var debug: bool

var _current_round: int = 1
var _current_enemy_counter: int
var _current_time: int = 1
var _enemy_array: Array[Enemy]

var player: Player
var camera: Camera2D
var spawn_timer: Timer

@onready var timer_gui: TimerGUI = %TimerGUI
@onready var debug_label: Label = %DebugLabel

func _ready():

	if not debug:
		player = PLAYER.instantiate()
		add_child(player)
	else:
		player = get_tree().get_first_node_in_group("Player")
	
	player.entity_death.connect(_game_over)

	spawn_timer = Timer.new()
	spawn_timer.wait_time = 1
	add_child(spawn_timer)
	spawn_timer.timeout.connect(spawn_enemies)
	
	camera = Camera2D.new()
	camera.zoom = Vector2(3, 3)
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 2.5
	player.add_child(camera)

	timer_gui.timeout.connect(_change_round)
	timer_gui.max_value = round_time
	
	timer_gui.play()
	spawn_timer.start()
	

func _process(_delta) -> void:
	debug_label.text = "ROUND \n" + str(_current_round) + "/" + str(max_round)

func _physics_process(delta):
	for enemy: Enemy in _enemy_array:
		enemy.velocity = (player.global_position - enemy.global_position).normalized() * enemy.speed
		if (player.global_position - enemy.global_position).normalized().x > 0:
			enemy.sprite.scale.x = 1
		else:
			enemy.sprite.scale.x = -1
		enemy.move_and_slide()

func _unhandled_key_input(event):
	if event.is_action_pressed("pause_game"):
		%PauseMenu.label.text = "Pause"
		%PauseMenu.visible = not %PauseMenu.visible

func spawn_enemies():
	for info: SpawnInfo in spawn:
		if _current_round in info.round_spawn:
			if _current_time >= info.time_start and _current_time <= info.time_end:
				if _current_enemy_counter < max_enemy_counter:
					var counter = 0
					while counter < info.enemy_interval:
						var enemy_spawn = info.enemy.instantiate()
						enemy_spawn.entity_death.connect(_clear_enemies.bind(enemy_spawn))
						enemy_spawn.global_position = _get_random_position()
						add_child(enemy_spawn, true)
						_enemy_array.append(enemy_spawn)
						_current_enemy_counter += 1
						counter += 1
	
	_current_time += 1

func _game_over():
	%PauseMenu.label.text = "You Lose :("
	%PauseMenu.resume = false
	%PauseMenu.visible = true

func _change_round():
	spawn_timer.stop()
	for child: Node in get_children():
		if child is Enemy:
			child.on_death(false)
	
	if _current_round == max_round:
		%PauseMenu.label.text = "You WIN!"
		%PauseMenu.resume = false
		%PauseMenu.visible = true
		return
	
	var tween := create_tween()
	tween.tween_property(timer_gui, "value", round_time, time_per_round)
	tween.parallel().tween_property(player, "health", player.max_health, time_per_round)
	await tween.finished
	timer_gui.play()
	spawn_timer.start(0)
	
	_current_round += 1
	_current_time = 1

func _clear_enemies(enemy_reference: Enemy):
	_current_enemy_counter -= 1
	_enemy_array.erase(enemy_reference)

func _get_random_position():
	var vpr = get_viewport_rect().size * randf_range(1.1, 1.4)
	vpr /= 3
	var top_left = Vector2(player.global_position.x - vpr.x / 2, player.global_position.y - vpr.y / 2)
	var top_right = Vector2(player.global_position.x + vpr.x / 2, player.global_position.y - vpr.y / 2)
	var bottom_left = Vector2(player.global_position.x - vpr.x / 2, player.global_position.y + vpr.y / 2)
	var bottom_right = Vector2(player.global_position.x + vpr.x / 2, player.global_position.y + vpr.y / 2)
	var pos_side = ["up", "down", "right", "left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
	
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y, spawn_pos2.y)
	return Vector2(x_spawn, y_spawn)



func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
