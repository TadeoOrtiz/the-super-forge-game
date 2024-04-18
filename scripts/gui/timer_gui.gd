class_name TimerGUI
extends VBoxContainer


var max_value: int:
	set(value):
		max_value = value
		_progress_bar.max_value = max_value
@onready var value: int = max_value:
	set(_value):
		value = _value
		var _mins = (value % 3600) / 60
		var _sec = value % 60
		_timer_label.text = str(_mins) + ":" + str(_sec)
		_progress_bar.value = value


@onready var _timer_label: Label = %Timer
@onready var _progress_bar: ProgressBar = %Progress


