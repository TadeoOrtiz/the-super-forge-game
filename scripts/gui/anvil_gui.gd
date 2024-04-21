class_name AnvilInterface
extends Control

const SLOT = preload ("res://nodes/gui/inventory_slot.tscn")

@onready var recipe_list: ItemList = %RecipeList
@onready var ingredients_container: GridContainer = %IngredientContainer
@onready var result_container: GridContainer = %ResultContainer
@onready var forge_button: Button = %ForgeButton

func add_recipe(recipe: ItemRecipe) -> void:
	recipe_list.add_item(recipe.recipe_name)

func clear_crafting():
	for child in ingredients_container.get_children():
		child.queue_free()
	for child in result_container.get_children():
		child.queue_free()

func _on_recipe_list_item_selected(index: int):
	clear_crafting()

	var recipe: ItemRecipe = ResourcesManager.ITEMS_RECIPES_RESOURCE.load_all()[index]
	for ingredient: Slot in recipe.ingredients:
		var slot = SLOT.instantiate()
		ingredients_container.add_child(slot)
		slot.display(ingredient)
	
	for result: Slot in recipe.results:
		var slot = SLOT.instantiate()
		result_container.add_child(slot)
		slot.display(result)
