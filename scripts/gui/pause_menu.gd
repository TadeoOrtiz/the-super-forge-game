extends ColorRect

var resume: bool = true
@onready var label: Label = %Label

func _play_again():
	if resume:
		visible = false
	else:
		get_tree().reload_current_scene()

func _back_to_menu():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_visibility_changed():
	Engine.time_scale = int(not visible)
	if resume:
		%PlayAgainButton.text = "Resume"
	else:
		%PlayAgainButton.text = "Play Again"
