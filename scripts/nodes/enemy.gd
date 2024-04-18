class_name Enemy
extends CharacterBody2D

const ITEM_NODE = preload ("res://nodes/item_node.tscn")

@export var health: float = 100.0

var _target: Player

@export var loot: Array[Item]

func _ready():
    _target = get_tree().get_first_node_in_group("Player")

func _physics_process(_delta):
    velocity = (_target.global_position - global_position).normalized() * 40
    move_and_slide()

func on_death():
    for item: Item in loot:
        var item_node := ITEM_NODE.instantiate()
        item_node.item_resource = item.duplicate()
        item_node.position = global_position + Vector2(randf_range(-5, 5), randf_range(-5, 5))
        call_deferred("add_sibling", item_node)
    queue_free()
    
func _on_hurt_box_hurt(value: float):
    health -= value
    modulate = Color(15, 15, 15, 1)
    var tween = create_tween()
    tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.1)
    if health <= 0:
        on_death()
