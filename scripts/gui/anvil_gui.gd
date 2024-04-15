class_name AnvilInterface
extends Control

signal item_forged(item: Item)

const SLOT = preload ("res://nodes/gui/inventory_slot.tscn")

@onready var recipe_list: ItemList = %RecipeList
@onready var ingredients_container: GridContainer = %IngredientContainer
@onready var result_container: GridContainer = %ResultContainer

func add_recipe(recipe: ItemRecipe) -> void:
	recipe_list.add_item(recipe.recipe_name, recipe.result[0].icon)

func _on_recipe_list_item_selected(index: int):
	for child in ingredients_container.get_children():
		child.queue_free()
	for child in result_container.get_children():
		child.queue_free()

	var recipe: ItemRecipe = ResourcesManager.ITEMS_RECIPES_RESOURCE.load_all()[index]
	for ingredient: Item in recipe.ingredients:
		var slot = SLOT.instantiate()
		ingredients_container.add_child(slot)
		slot.display(ingredient)
	
	for result: Item in recipe.result:
		var slot = SLOT.instantiate()
		result_container.add_child(slot)
		slot.display(result)

func _on_forge_button_pressed():
	var recipes := ResourcesManager.ITEMS_RECIPES_RESOURCE.load_all()
	var recipe: ItemRecipe = recipes[recipe_list.get_selected_items()[0]]
	var item: Item = recipe.result[0]
	item_forged.emit(item)
