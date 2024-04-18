class_name SlotContainer
extends GridContainer

signal slot_picked(slot_index: int)

const SLOT = preload ("res://nodes/gui/inventory_slot.tscn")

func add_slot(slot: Slot, use_shortcut := false):
    var slot_gui = SLOT.instantiate()
    slot_gui.use_shortcut = use_shortcut
    slot_gui.gui_input.connect(_slot_gui_handler.bind(slot_gui))
    add_child(slot_gui, true)
    slot_gui.display(slot)

func update_slot(slot: Slot, slot_index: int):
    var slot_to_update = get_child(slot_index)
    slot_to_update.display(slot)

func _slot_gui_handler(event: InputEvent, slot: InventorySlot) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            if event.is_pressed():
                slot_picked.emit(slot.get_index())