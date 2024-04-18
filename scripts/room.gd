class_name Room
extends TileMap

const PLAYER: PackedScene = preload("res://nodes/player.tscn")
const ENEMY_SPAWENER: PackedScene = preload("res://nodes/enemy_spawner.tscn")


@export_category("DEBUG")
@export var debug: bool


var _enemy_spawner: EnemySpawner

var player: Player
var camera: Camera2D


@onready var timer_gui: TimerGUI = %TimerGUI


func _ready():
	if not debug:
		player = PLAYER.instantiate()
		_enemy_spawner = ENEMY_SPAWENER.instantiate()

		add_child(player)
		add_child(_enemy_spawner)
	else:
		player = get_tree().get_first_node_in_group("Player")
	
	camera = Camera2D.new()
	camera.zoom = Vector2(3, 3)
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 2.5
	player.add_child(camera)

	timer_gui.max_value = 100