class_name WeaponModel
extends Sprite2D

@export var bullet_position : Array[Marker2D]
@export var attack_animation: String


var shoot_type: Weapon.SHOOT_TYPE
var dispersion: float

@onready var anim_player: AnimationPlayer =  $AnimationPlayer

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("shoot"):
			_attack()

func on_attack():
	pass

func spawn_bullet():
	for bullet_pos in bullet_position:
		var bullet = load("res://nodes/bullet.tscn").instantiate()
		bullet.position = bullet_pos.global_position
		bullet.rotation = get_parent().rotation + deg_to_rad(randf_range(-dispersion, dispersion))
		bullet.set_as_top_level(true)
		add_sibling(bullet)

func _attack():
	if not anim_player.is_playing():
		on_attack()
	anim_player.play(attack_animation)

func _on_animation_player_animation_finished(_anim_name:StringName):
	if shoot_type == Weapon.SHOOT_TYPE.Auto:
		if Input.is_action_pressed("shoot"):
			_attack()
