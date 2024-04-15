class_name InventorySlot
extends Panel

@onready var texture_rect: TextureRect = $TextureRect

func display(item: Item=null):
	if item:
		texture_rect.texture = item.icon
	else:
		texture_rect.texture = null