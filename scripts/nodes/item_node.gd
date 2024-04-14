class_name ItemNode
extends Area2D

@export var item_resource: Item

func _ready() -> void:
    %Sprite.texture = item_resource.icon

func on_pickup(target: Node) -> Item:
    var teween := create_tween()
    get_class()
    teween.tween_property(self, "position", target.global_position, 0.05)
    teween.finished.connect(queue_free)
    return item_resource