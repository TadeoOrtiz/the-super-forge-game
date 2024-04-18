class_name InventorySlot
extends Panel

@onready var item_texture: TextureRect = %ItemTexture
@onready var quantity_label: Label = %Quantity
@onready var shortcut_label: Label = %Shortcut

var use_shortcut: bool

func _ready():
	shortcut_label.visible = use_shortcut
	if "weapon_hotbar_0" + str(get_index()) in InputMap.get_actions():
		shortcut_label.text = str(get_index() + 1)

func display(slot: Slot=null):
	if not slot.is_empty():
		item_texture.texture = slot.item.icon
		quantity_label.text = str(slot.quantity)
		if slot.quantity <= 1:
			quantity_label.text = ""
	else:
		item_texture.texture = null
		quantity_label.text = ""

func _on_item_texture_mouse_entered():
	self_modulate = Color(2, 2, 2, 1)

func _on_item_texture_mouse_exited():
	self_modulate = Color(1, 1, 1, 1)
