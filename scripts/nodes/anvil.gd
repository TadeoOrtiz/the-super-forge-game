class_name Anvil
extends StaticBody2D


func open():
	$CanvasLayer.show()
	print(ResourcesManager.find_recipe("rifle"))

func close():
	$CanvasLayer.hide()