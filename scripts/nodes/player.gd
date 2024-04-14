class_name Player
extends CharacterBody2D

@export var speed: float = 100.0
@export var gun: Item:
    set(value):
        gun = value
        update_ae()

# Private vars
var _pointing_direction: Vector2
var _inventory: Array[Item]

# Onready vars
@onready var hand: Marker2D = %Hand
@onready var anim_player: AnimationPlayer = %AnimationPlayer
@onready var item_pickup_sound: AudioStreamPlayer2D = $ItemPickupSound

#region Built-in Methods
func _ready():
    update_ae()

func _physics_process(_delta: float) -> void:

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
    
    var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    
    velocity = direction * speed

    match velocity:
        Vector2.ZERO:
            anim_player.play("idle")
        _:
            anim_player.play("walk")
    
    move_and_slide()

func _unhandled_key_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
            shoot()

#endregion

#region Public Methods
func shoot():
    var bullet = load("res://nodes/bullet.tscn").instantiate()
    bullet.position = global_position
    bullet.rotation = hand.rotation
    add_sibling(bullet)

func update_ae():
    if hand:
        hand.get_node("Gun").texture = gun.icon

#endregion

#region Private Methods
func _on_interact_entered(interactable: Node) -> void:
    if interactable is ItemNode:
        _inventory.append(interactable.on_pickup(self))
        item_pickup_sound.play()
    elif interactable is Anvil:
        interactable.open()

func _on_interact_exited(interactable: Node) -> void:
    if interactable is Anvil:
        interactable.close()

#endregion