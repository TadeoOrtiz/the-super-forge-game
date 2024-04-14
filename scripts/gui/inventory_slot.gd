class_name InventorySlot
extends Panel

@onready var texture_rect: TextureRect = $TextureRect

func display(item: Item=null):
	texture_rect.texture = item.icon if item else null
