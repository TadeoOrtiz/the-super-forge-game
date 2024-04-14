extends Node

const ITEMS_RECIPES_RESOURCE: ResourceGroup = preload ("res://resource_groups/recipes.tres")
const ITEMS_RESOURCE: ResourceGroup = preload ("res://resource_groups/items.tres")

func find_recipe(recipe_name: String) -> ItemRecipe:
    var recipes_array: Array[Resource] = ITEMS_RECIPES_RESOURCE.load_all()
    
    for recipe: ItemRecipe in recipes_array:
        if recipe.recipe_name == recipe_name:
            return recipe
    return null