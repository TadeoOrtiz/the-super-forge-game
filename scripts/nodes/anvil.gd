class_name Anvil
extends StaticBody2D

signal item_forged

@export var canvas_layer: CanvasLayer
@export var gui: Control

var target: Player

func _ready():
	gui.forge_button.pressed.connect(_on_forge)

func open():
	canvas_layer.show()
	for recipe in ResourcesManager.ITEMS_RECIPES_RESOURCE.load_all():
		gui.add_recipe(recipe)

func close():
	canvas_layer.hide()
	gui.recipe_list.clear()

func _on_forge():
	if not gui.recipe_list.is_anything_selected():
		return
	if not target.inventory.is_empty():
		return

	var recipes := ResourcesManager.ITEMS_RECIPES_RESOURCE.load_all()
	var recipe: ItemRecipe = recipes[gui.recipe_list.get_selected_items()[0]]

	var can_forge: bool

	for slot: Slot in recipe.ingredients:
		can_forge = target.inventory.find_item_by_id(slot.item.id, slot.quantity) != - 1

	if can_forge:
		for slot: Slot in recipe.ingredients:
			target.inventory.remove_item_by_id(slot.item.id, slot.quantity)
		
		for slot: Slot in recipe.results:
			target.inventory.add_item(slot.item, slot.quantity)
