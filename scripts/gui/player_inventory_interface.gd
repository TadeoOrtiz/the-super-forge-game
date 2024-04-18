class_name PlayerInventoryInterface
extends VBoxContainer

const SLOT = preload ("res://nodes/gui/inventory_slot.tscn")

@export var player: Player

var _slot_draged: InventorySlot
var _slot_draged_data: Slot

@onready var inventory: SlotContainer = %Inventory
@onready var weapons: SlotContainer = %Weapons

func _ready():
	player.inventory.item_added.connect(inventory.update_slot)
	player.inventory.item_removed.connect(inventory.update_slot)
	
	inventory.slot_picked.connect(_slot_picked.bind(player.inventory))

	for slot: Slot in player.inventory.items:
		inventory.add_slot(slot)

	player.weapons_inventory.item_added.connect(weapons.update_slot)
	player.weapons_inventory.item_removed.connect(weapons.update_slot)

	weapons.slot_picked.connect(_slot_picked.bind(player.weapons_inventory))
	
	for slot: Slot in player.weapons_inventory.items:
		weapons.add_slot(slot, true)

func _process(_delta):
	if _slot_draged:
		_slot_draged.position = get_local_mouse_position() - _slot_draged.size / 2

func _slot_picked(slot_index: int, _inventory: Inventory):
	var inv_slot := _inventory.pick_item(slot_index)
	if inv_slot.item and not _slot_draged_data:
		_slot_draged_data = inv_slot
		_slot_draged = SLOT.instantiate()
		add_sibling(_slot_draged)
		_slot_draged.self_modulate = Color(0, 0, 0, 0)
		_slot_draged.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_slot_draged.display(_slot_draged_data)
	elif not inv_slot.item and _slot_draged_data:
		if not _inventory.put_item(slot_index, _slot_draged_data):
			return
		_slot_draged_data = null
		_slot_draged.queue_free()
		_slot_draged = null
	elif inv_slot.item and _slot_draged_data:
		if not _inventory.put_item(slot_index, _slot_draged_data):
			_inventory.put_item(slot_index, inv_slot)
			return
		_slot_draged_data = inv_slot
		_slot_draged.display(_slot_draged_data)
		