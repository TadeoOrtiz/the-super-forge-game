class_name Enemy
extends CharacterBody2D

const ITEM_NODE = preload("res://nodes/item_node.tscn")

@export var loot : Item

func _physics_process(delta):
    velocity = -global_position.normalized() * 40
    move_and_slide()

func on_death(target : Node):
    if target is Projectile:
        target.queue_free()
    
    var item_node := ITEM_NODE.instantiate()
    item_node.item_resource = loot.duplicate()
    item_node.position = global_position
    call_deferred("add_sibling", item_node)
    queue_free()
    