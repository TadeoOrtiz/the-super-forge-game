class_name TimerGUI
extends VBoxContainer

signal timeout

var max_value: int:
	set(value):
		max_value = value
		_progress_bar.max_value = max_value
		timer.wait_time = max_value
@onready var value: float = max_value:
	set(_value):
		value = _value
		_progress_bar.value = value
		var _mins = (int(value) % 3600) / 60
		var _sec = int(value) % 60
		_timer_label.text = str(_mins) + ":" + str(_sec)


@onready var timer: Timer = $Timer

@onready var _timer_label: Label = %TimerLabel
@onready var _progress_bar: TextureProgressBar = %Progress

func play():
	timer.start()

func _process(_delta):
	value = timer.time_left


func _on_timer_timeout():
	timeout.emit()
