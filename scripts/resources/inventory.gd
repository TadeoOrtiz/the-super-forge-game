class_name Inventory
extends Resource

signal item_added(slot: Slot, index: int)
signal item_removed(slot: Slot, index: int)
signal inventory_cleaned

var size: int:
    set(value):
        size = value
        items.resize(size)
        for i in items.size():
            if not items[i]:
                items[i] = Slot.new()
                items[i].index = i
                items[i].slot_type = items[i - 1].slot_type
var items: Array[Slot]

func _init(_size: int, slot_type : Item.SLOT_TYPE):
    items.resize(_size)
    for i in items.size():
        if not items[i]:
            items[i] = Slot.new()
            items[i].index = i
            items[i].slot_type = slot_type
    size = _size

func add_item(item: Item, quantity:=1) -> void:
    for slot: Slot in items:
        # Slot is empty
        if slot.is_empty():
            slot.item = item
            slot.quantity = quantity
            item_added.emit(slot, slot.index)
            break
        else:
            # Compare items
            if slot.item.id == item.id:
                if item.is_stackeable:
                    slot.quantity += quantity
                    item_added.emit(slot, slot.index)
                    break
                
func remove_item_by_id(item_id: String, quantity:=1) -> int:
    for slot: Slot in items:
        if not slot.is_empty():
            if slot.item.id == item_id:
                slot.quantity -= quantity
                if slot.quantity <= 0:
                    slot.item = null
                    slot.quantity = 0
                    item_removed.emit(slot, slot.index)
                    return slot.index
                item_removed.emit(slot, slot.index)
                return slot.index
    return - 1

func remove_item(slot_index: int, quantity := 1) -> void:
    items[slot_index].quantity -= quantity
    if items[slot_index].quantity <= 0:
        items[slot_index].item = null
    item_removed.emit(items[slot_index], slot_index)

func find_item_by_id(item_id: String, quantity:=1) -> int:
    for slot: Slot in items:
        if not slot.is_empty():
            if slot.item.id == item_id and slot.quantity >= quantity:
                return slot.index
    return - 1

func pick_item(slot_index: int) -> Slot:
    var slot: Slot = items[slot_index].duplicate()
    remove_item(slot_index, slot.quantity)
    return slot

func put_item(slot_index: int, slot: Slot) -> bool:
    if not slot.item.slot_type == items[slot_index].slot_type:
        if not items[slot_index].slot_type == Item.SLOT_TYPE.Default:
            return false

    if items[slot_index].item:
        if items[slot_index].item.id == slot.item.id:
            items[slot_index].quantity += slot.quantity
    else:
        items[slot_index].item = slot.item
        items[slot_index].quantity = slot.quantity
        
    item_added.emit(items[slot_index], slot_index)
    return true

func is_empty() -> bool:
    for slot: Slot in items:
        if slot.is_empty():
            return true
    return false

func clear():
    for slot: Slot in items:
        slot.item = null
        slot.quantity = 0
    inventory_cleaned.emit()
