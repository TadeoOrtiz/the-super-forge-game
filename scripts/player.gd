class_name Player
extends CharacterBody2D

@export var speed: float = 100.0

# Private vars
var mouse_direction: Vector2

# Onready vars
@onready var hand: Marker2D = %Hand
@onready var anim_player: AnimationPlayer = %AnimationPlayer

func _physics_process(_delta: float) -> void:

    mouse_direction = get_global_mouse_position()

    hand.look_at(mouse_direction)
    if get_local_mouse_position().x < 0:
        %Sprite.scale.x = -1
        hand.scale.y = -1
    else:
        %Sprite.scale.x = 1
        hand.scale.y = 1
    
    var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

    velocity = direction * speed

    match velocity:
        Vector2.ZERO:
            anim_player.play("idle")
        _:
            anim_player.play("walk")
    
    move_and_slide()