class_name Enemy
extends CharacterBody2D

signal entity_death

const ITEM_NODE = preload ("res://nodes/item_node.tscn")

@export var health: float = 100.0
@export var speed: float = 40
@export var loot: Array[Item]

var _target: Player

@onready var _anim_player: AnimationPlayer = %AnimationPlayer

func _ready():
    _target = get_tree().get_first_node_in_group("Player")
    _anim_player.play("walk")

func _physics_process(_delta):
    velocity = (_target.global_position - global_position).normalized() * speed
    if (_target.global_position - global_position).normalized().x > 0:
        $Sprite2D.scale.x = 1
    else:
        $Sprite2D.scale.x = -1
    move_and_slide()

func on_death(drop_loot: bool=true):
    if drop_loot:
        for item: Item in loot:
            var item_node := ITEM_NODE.instantiate()
            item_node.item_resource = item.duplicate()
            call_deferred("add_sibling", item_node)
            item_node.global_position = global_position + Vector2(randf_range( - 5, 5), randf_range( - 5, 5))
    _anim_player.play("death")
    entity_death.emit()
    call_deferred("queue_free")
    
func _on_hurt_box_hurt(value: float):
    health -= value
    _anim_player.play("hurt")
    if health <= 0:
        if not $HurtBox.disabled:
            $HurtBox.disabled = true
            on_death()
    else:
        await _anim_player.animation_finished
        _anim_player.play("walk")