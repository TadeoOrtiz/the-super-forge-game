extends Control

func _play():
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/test_room.tscn")

func _exit():
	get_tree().quit()