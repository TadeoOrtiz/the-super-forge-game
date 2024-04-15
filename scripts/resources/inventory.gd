class_name Inventory
extends Resource

var size: int:
    set(value):
        size = value
        items.resize(size)
        for i in items.size():
            if not items[i]:
                items[i] = Slot.new()
var items: Array[Slot]

func _init(_size: int):
    size = _size
    items.resize(size)
    for i in items.size():
        if not items[i]:
            items[i] = Slot.new()


func add_item(item: Item, quantity := 1) -> void:
    for inventory_slot: Slot in items:
        # Slot is empty
        if inventory_slot.is_empty():
            inventory_slot.item = item
            inventory_slot.quantity = quantity
            break
        else:
            # Compare items
            if inventory_slot.item.id == item.id:
                if item.is_stackeable:
                    inventory_slot.quantity += quantity
                    break
                

class Slot:
    var item: Item
    var quantity: int

    func _to_string():
        return '[item: {item}, quantity: {quantity}]'.format({"item": item, "quantity": quantity})
    
    func is_empty():
        return item == null