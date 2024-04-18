class_name Player
extends CharacterBody2D

@export var speed: float = 100.0
@export var max_health: float = 100.0:
	set(value):
		max_health = value
		health_bar.max_value = max_health

# Public vars
var inventory := Inventory.new(12, Item.SLOT_TYPE.Default)
var weapons_inventory := Inventory.new(6, Item.SLOT_TYPE.Weapons)

# Private vars
var _pointing_direction: Vector2
var _interactable_nearby: Array[Node]

# Onready vars
@onready var hand: Marker2D = %Hand
@onready var anim_player: AnimationPlayer = %AnimationPlayer
@onready var item_pickup_sound: AudioStreamPlayer2D = $ItemPickupSound

@onready var inventory_interface: PlayerInventoryInterface = %PlayerInventoryInterface
@onready var health_bar: ProgressBar = %HealthBar


@onready var health: float = max_health:
	set(value):
		health = value
		health_bar.value = health

#region Built-in Methods

func _ready():
	health_bar.max_value = max_health
	health_bar.value = health

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	
	if hand.get_children().size() > 0:
		_pointing_direction = get_global_mouse_position() - global_position
		
		hand.look_at(_pointing_direction + global_position)
		if _pointing_direction.x < 0:
			%Sprite.scale.x = -1
			hand.scale.y = -1
			hand.z_index = -1
		else:
			%Sprite.scale.x = 1
			hand.scale.y = 1
			hand.z_index = 1
	elif direction.x != 0:
		%Sprite.scale.x = roundi(direction.x)

	velocity = direction * speed

	match velocity:
		Vector2.ZERO:
			anim_player.play("idle")
		_:
			anim_player.play("walk")

	move_and_slide()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("weapon_hotbar_01"):
		_spawn_weapon_model(0)
	elif event.is_action_pressed("weapon_hotbar_02"):
		_spawn_weapon_model(1)
	elif event.is_action_pressed("weapon_hotbar_03"):
		_spawn_weapon_model(2)
	elif event.is_action_pressed("weapon_hotbar_04"):
		_spawn_weapon_model(3)
	elif event.is_action_pressed("weapon_hotbar_05"):
		_spawn_weapon_model(4)
	elif event.is_action_pressed("weapon_hotbar_06"):
		_spawn_weapon_model(5)
	
	if event.is_action_pressed("open_inventory"):
		inventory_interface.visible = not inventory_interface.visible
		for node in _interactable_nearby:
			if inventory_interface.visible:
				node.open()
			else:
				node.close()
		
#endregion

#region Private Methods
func _on_interact_entered(interactable: Node) -> void:
	if interactable is ItemNode:
		item_pickup_sound.play()
		inventory.add_item(interactable.on_pickup(self))
	elif interactable is Anvil:
		interactable.target = self
		_interactable_nearby.append(interactable)
		for node in _interactable_nearby:
			if inventory_interface.visible:
				interactable.open()

func _on_interact_exited(interactable: Node) -> void:
	if interactable is Anvil:
		interactable.target = null
		for node in _interactable_nearby:
			if node == interactable:
				interactable.close()
		_interactable_nearby.erase(interactable)

func _on_hurt_box_hurt(value: float):
	var tween := create_tween()
	%Sprite.modulate = Color(15, 15, 15, 1)
	tween.tween_property(self, "health", health - value, 0.25)
	tween.parallel().tween_property(%Sprite, "modulate", Color(1, 1, 1, 1), 0.1)


func _spawn_weapon_model(inv_index: int):
	for child in hand.get_children():
		child.queue_free()
	
	if weapons_inventory.items[inv_index].item:
		var weapon: WeaponModel = weapons_inventory.items[inv_index].item.model.instantiate()
		weapon.dispersion = weapons_inventory.items[inv_index].item.dispersion
		weapon.shoot_type = weapons_inventory.items[inv_index].item.shoot_type
		hand.add_child(weapon)
#endregion
