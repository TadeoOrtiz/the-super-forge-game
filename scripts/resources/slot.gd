class_name Slot
extends Resource



@export var item: Item
@export var quantity: int
@export var slot_type := Item.SLOT_TYPE.Default

var index: int



func _to_string():
    return '[item: {item}, quantity: {quantity}, "type": {slot_type}]'.format({"item": item, "quantity": quantity, "slot_type": slot_type})

func is_empty():
    return item == null
