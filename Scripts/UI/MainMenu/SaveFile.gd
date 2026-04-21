class_name SaveFile
extends Button

signal save_file_selected(save_file_index: int)

var save_file_index: int = -1
var main_progress: float = 0.0
var extra_progress: float = 0.0
var time: String = "-- : -- : --"
var has_data = false

@onready var main_progress_bar: ProgressBar = $MainProgressBar
@onready var extra_progress_bar: ProgressBar = $ExtraProgressBar
@onready var time_label: Label = $MarginContainer/Time
@onready var save_file_label: Label = $SaveFileText

func _ready() -> void:
	main_progress_bar.value = main_progress
	extra_progress_bar.value = extra_progress
	time_label.text = time
	if has_data:
		save_file_label.text = "Load Save File " + str(save_file_index + 1)
	else:
		save_file_label.text = "Begin New Game"

	connect("pressed", _on_pressed)

func _on_pressed() -> void:
	emit_signal("save_file_selected", save_file_index)
