class_name Anvil
extends StaticBody2D

@onready var gui = %AnvilGui

var target: Player

func open():
	for recipe in ResourcesManager.ITEMS_RECIPES_RESOURCE.load_all():
		gui.add_recipe(recipe)

	$CanvasLayer.show()

func close():
	gui.recipe_list.clear()
	$CanvasLayer.hide()

func _on_anvil_gui_item_forged(item: Item):
	target._inventory.add_item(item)
