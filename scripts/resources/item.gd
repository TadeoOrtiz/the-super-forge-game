class_name Item
extends Resource

@export var id: String
@export var name: String
@export var is_stackeable: bool = true
@export var icon: Texture2D

func _to_string() -> String:
    return id