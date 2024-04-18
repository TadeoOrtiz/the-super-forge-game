class_name Item
extends Resource

enum SLOT_TYPE{
	Default,
	Weapons
}


@export var id: String
@export var name: String
@export var is_stackeable: bool = true
@export var icon: Texture2D
@export var slot_type := SLOT_TYPE.Default

func _to_string() -> String:
    return id